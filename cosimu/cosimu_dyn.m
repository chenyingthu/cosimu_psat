function  ResultData = cosimu_dyn(Config, CurrentStatus, ResultData)
global Fig Settings Snapshot Hdl
global Bus File DAE Theme OMIB
global SW PV PQ Fault Ind Syn Exc Tg
global Varout Breaker Line Path clpsat

if ~autorun('Time Domain Simulation',1), return, end

tic

%% initial messages
% -----------------------------------------------------------------------

fm_disp

if DAE.n == 0 && ~clpsat.init
    Settings.ok = 0;
    uiwait(fm_choice('No dynamic component is loaded. Continue anyway?',1))
    if ~Settings.ok
        fm_disp('Time domain simulation aborted.',2)
        return
    end
end

fm_disp('Time domain simulation')
switch Settings.method
    case 1,
        fm_disp('Implicit Euler integration method')
    case 2,
        fm_disp('Trapezoidal integration method')
end
fm_disp(['Data file "',Path.data,File.data,'"'])
if ~isempty(Path.pert),
    fm_disp(['Perturbation file "',Path.pert,File.pert,'"'])
end
if (strcmp(File.pert,'pert') && strcmp(Path.pert,Path.psat)) || ...
        isempty(File.pert)
    fm_disp('No perturbation file set.',1)
end

% check settings
% ------------------------------------------------------------------

iter_max = Settings.dynmit;
tol = Settings.dyntol;
Dn = 1;
if DAE.n, Dn = DAE.n; end
identica = speye(max(Dn,1));

if (Fault.n || Breaker.n) && PQ.n && ~Settings.pq2z
    if clpsat.init
        if clpsat.pq2z
            Settings.pq2z = 1;
        else
            Settings.pq2z = 0;
        end
    elseif ~Settings.donotask
        uiwait(fm_choice(['Convert (recommended) PQ loads to constant impedances?']))
        if Settings.ok
            Settings.pq2z = 1;
        else
            Settings.pq2z = 0;
        end
    end
end

% convert PQ loads to shunt admittances (if required)
PQ = pqshunt(PQ);

% set up variables
% ----------------------------------------------------------------

DAE.t = Settings.t0;
fm_call('i');
DAE.tn = DAE.f;
if isempty(DAE.tn), DAE.tn = 0; end


% ----------------------------------------------------------------
% initializations
% ----------------------------------------------------------------

t = Settings.t0;
k = 1;
h = fm_tstep(1,1,0,Settings.t0);
inc = zeros(Dn+DAE.m,1);
callpert = 1;

% get initial network connectivity
fm_flows('connectivity', 'verbose');


% time vector of snapshots, faults and breaker events
fixed_times = [];

n_snap = length(Snapshot);
if n_snap > 1 && ~Settings.locksnap
    snap_times = zeros(n_snap-1,1);
    for i = 2:n_snap
        snap_times(i-1,1) = Snapshot(i).time;
    end
    fixed_times = [fixed_times; snap_times];
end

fixed_times = [fixed_times; gettimes(Fault); ...
    gettimes(Breaker); gettimes(Ind)];
fixed_times = sort(fixed_times);

nHour = 1;
load([Config.loadShapeFile, num2str(nHour)]);
loadshape = hourDataNew;
nPointOfLoadShape = 0;
sizeOfLoadShape = length(loadshape);

% compute max rotor angle difference
diff_max = anglediff;


% ================================================================
% ----------------------------------------------------------------
% Main loop
% ----------------------------------------------------------------
% ================================================================

inc = zeros(Dn+DAE.m,1);

while (t < Settings.tf) && (t + h > t) && ~diff_max
    
    %% one step integration
    if (t + h > Settings.tf), h = Settings.tf - t; end
    actual_time = t + h;
    
    % check not to jump disturbances
    index_times = find(fixed_times > t & fixed_times < t+h);
    if ~isempty(index_times);
        actual_time = min(fixed_times(index_times));
        h = actual_time - t;
    end
    
    % set global time
    DAE.t = actual_time;
    
    % backup of actual variables
    if isempty(DAE.x), DAE.x = 0; end
    xa = DAE.x;
    ya = DAE.y;
    
    % initialize NR loop
    iterazione = 1;
    inc(1) = 1;
    if isempty(DAE.f), DAE.f = 0; end
    fn = DAE.f;
    
    % applying faults, breaker interventions and perturbations
    if ~isempty(fixed_times)
        if ~isempty(find(fixed_times == actual_time))
            Fault = intervention(Fault,actual_time);
            Breaker = intervention(Breaker,actual_time);
            %% add some code to deal with the optimal powerflow model
            lineIdx = ResultData.allLineIdx(Breaker.line);
            CurrentStatus.branch(lineIdx, 11) = Breaker.u;
        end
    end
    
    
    if Config.enableLoadShape == 1
        
        %% increase the load acording the loadshape
        nPointOfLoadShape = nPointOfLoadShape + 1;        
        
        if nPointOfLoadShape > sizeOfLoadShape
            nHour = nHour + 1;
            load([Config.loadShapeFile, num2str(nHour)]);
            loadshape = hourDataNew;
            nPointOfLoadShape = 1;
            sizeOfLoadShape = length(loadshape);
        end
        PQ.con(:, [4, 5]) = loadshape(nPointOfLoadShape) * ResultData.loadBase;
        
        
        
    end
    
    %
    % Newton-Raphson loop
    Settings.error = tol+1;
    while Settings.error > tol
        if (iterazione > iter_max)
            disp(['dyn iteration not converged for ', num2str( actual_time)]);
            break
        end
        
        % DAE equations
        fm_call('i');
        
        % complete Jacobian matrix DAE.Ac
        switch Settings.method
            case 1  % Forward Euler
                DAE.Ac = [identica - h*DAE.Fx, -h*DAE.Fy; DAE.Gx, DAE.Gy];
                DAE.tn = DAE.x - xa - h*DAE.f;
            case 2  % Trapezoidal Method
                DAE.Ac = [identica - h*0.5*DAE.Fx, -h*0.5*DAE.Fy; DAE.Gx, DAE.Gy];
                DAE.tn = DAE.x - xa - h*0.5*(DAE.f + fn);
        end
        
        % Non-windup limiters
        fm_call('5');
        inc = -DAE.Ac\[DAE.tn; DAE.g];
        
        
        DAE.x = DAE.x + inc(1:Dn);
        DAE.y = DAE.y + inc(1+Dn: DAE.m+Dn);
        iterazione = iterazione + 1;
        Settings.error = max(abs(inc));
    end
    
    if (iterazione > iter_max)
        h = fm_tstep(2,0,iterazione,t);
        DAE.x = xa;
        DAE.y = ya;
        DAE.f = fn;
    else
        h = fm_tstep(2,1,iterazione,t);
        t = actual_time;
        k = k+1;                
        i_plot = 1+k-10*fix(k/10);
        perc = (t-Settings.t0)/(Settings.tf-Settings.t0);
        if i_plot == 10
            fm_disp([' > Simulation time = ',num2str(DAE.t), ...
                ' s (',num2str(round(perc*100)),'%)'])
        end
        
    end
    
    
    
    % compute max rotor angle difference
    diff_max = anglediff;
    
    %% sampling all real history records from PSAT
    ResultData = recordRealSystemStatus(t, Config, ResultData);
    
    
    if Config.enableOPFCtrl == 1
        %     %% check the voltages of all buses to shed/recovery load
        %     ResultData = LoadShedAndRecovery(Config,ResultData);
       
        %     %% do control according opf result
        if abs(t - ResultData.nOpf*Config.controlPeriod) <= Settings.tstep
            %         % make measurements for control center to do opf control
            CurrentStatus = sampleAllMeasurements(Config, ResultData, CurrentStatus);
            [ResultData, isOpfConverged] = obtainOpfControlCommand( CurrentStatus, ResultData, Config);
            if (isOpfConverged)
                disp(['opf converged for the time ', num2str(t)]);
                ResultData = addCmd2CtrlOperationQueue(ResultData, Config);
                ResultData = addNetLag2CtrlOperationQueue(ResultData, Config);
            end
            ResultData.nOpf = ResultData.nOpf + 1;
        end
        %
        [ResultData, hasOptEvent, opts ] = hasOperationEvent(Config, ResultData, t);
        %
        if hasOptEvent
            nOpt = length(opts);
            for i = 1 : nOpt
                %% adjust the vref of avr
                if ~Exc.n
                    disp('no excitor defined');
                else
                    syns = Exc.syn;
                    for iSyn = 1 : Exc.n
                        synIdx = syns(iSyn);
                        ctrlSigIdx = ResultData.allGenIdx(synIdx);
                        Exc.vref0(iSyn) = opts(i).vGen(ctrlSigIdx);
                    end
                end
                if ~Tg.n
                    disp('no turbine governer defined');
                else
                    syns = Tg.syn;
                    for iSyn = 1 : Tg.n
                        synIdx = syns(iSyn);
                        ctrlSigIdx = ResultData.allGenIdx(synIdx);
                        % for type 1 tg
                        Tg.dat1(iSyn, 6) = opts(i).pGen(ctrlSigIdx);
                    end
                end
            end
            
        end
        
    end
    
    
end
disp(['haha =============>  simulation end with t = ', num2str(t)]);






%% compute delta difference at each step
% -----------------------------------------------------------------------
function diff_max = anglediff
global Settings Syn Bus DAE SW OMIB

diff_max = 0;

if ~Settings.checkdelta, return, end
if ~Syn.n, return, end

delta = DAE.x(Syn.delta);
[idx,ia,ib] = intersect(Bus.island,getbus(Syn));
if ~isempty(idx), delta(ib) = []; end

if isscalar(delta)
    delta = [delta; DAE.y(SW.refbus)];
end
delta_diff = abs(delta-min(delta));
diff_max = (max(delta_diff)*180/pi) > Settings.deltadelta;
if diff_max, return, end

