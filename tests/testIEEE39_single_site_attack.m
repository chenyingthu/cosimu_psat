%1. to run opendss in matlab;
%2. to simulate the voltage control with only local control strategies
clear ;
% clear classes;
cd ..
addpath([pwd, '\coSimu']);
addpath([pwd, '\psat']);
addpath([pwd, '\psat\filters']);
addpath([pwd, '\matpower4.1']);
addpath([pwd, '\matpower4.1\extras\se']);
addpath([pwd, '\debug']);
addpath([pwd, '\loadshape']);
pwdpath = pwd;

PQ = [ ...
    3 100.0   100.00  3.22000  0.02400 1.1 0.9 1;
    4 100.0   100.00  5.00000  1.84000 1.1 0.9 1;
    7 100.0   100.00  2.33800  0.84000 1.1 0.9 1;
    8 100.0   100.00  5.22000  1.76000 1.1 0.9 1;
    12 100.0   100.00  0.08500  0.88000 1.1 0.9 1;
    15 100.0   100.00  3.20000  1.53000 1.1 0.9 1;
    16 100.0   100.00  3.29000  0.32300 1.1 0.9 1;
    18 100.0   100.00  1.58000  0.30000 1.1 0.9 1;
    20 100.0   100.00  6.80000  1.03000 1.1 0.9 1;
    21 100.0   100.00  2.74000  1.15000 1.1 0.9 1;
    23 100.0   100.00  2.47500  0.84600 1.1 0.9 1;
    24 100.0   100.00  3.08600 -0.92200 1.1 0.9 1;
    25 100.0   100.00  2.24000  0.47200 1.1 0.9 1;
    26 100.0   100.00  1.39000  0.17000 1.1 0.9 1;
    27 100.0   100.00  2.81000  0.75500 1.1 0.9 1;
    28 100.0   100.00  2.06000  0.27600 1.1 0.9 1;
    29 100.0   100.00  2.83500  0.26900 1.1 0.9 1;
];

nBus = length(PQ(:,1));
Ee = [];
Eq = [];
Eeall = [];
Eqall = [];
for lagShema = 3: 4
for iBus = 1 : nBus
    bus = PQ(iBus);

    Config = initialConfig;
    %% base case there are no control or attacks
    %% user config for experiment
    Config.verbose = 0; % 0 not output details ; 1 output all logs
    Config.caseName = 'd_039ieee.m'; % case name for psat simulator
    Config.opfCaseName = 'case39'; % case name for the matpower4.1
    Config.simuType = 0; % 0 for pf based , 1 for transient model based
    Config.simuEndTime = 24*3600; % seconds based simulation time, 5*60 means 5 min;
    Config.controlPeriod = 3*60; % seconds based control interval, 2*60 means 2 min;
    Config.sampleRate  = 10; % secnods based sample rate for all measurements;
    Config.enableOPFCtrl = 1; % opf control should be used for this control;
    Config.enableLoadShape = 1; % load shape will not enable for this simulation;
    Config.lfTStep = 10; % seconds based time step for lf model driven simulation;
    Config.dynTStep = 0.05; % seconds based time step for dyn model driven simulation;
    Config.seEnable = 0; % 0 disable, 1 enable state estimation;
    Config.measLagSchema = lagShema; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.measAllLatency = 5; % for latency of Config.measAllLatency*Config.DSSStepsize
    Config.measLatencyChagePeriod = [15*3600, 18*3600];
    Config.measLaggedTunnel = [bus];
    Config.measTunnelLatency = [1e6];

    Config.ctrlLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.falseDataSchema = 0; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
    Config.measErroRatio = 0.3; % for the random erro
    %%%%%%%%%%%%%define a false attack element
    FalseData.toBus = 3;
    FalseData.strategy = 4; % for random erro on the pl and ql;
    FalseData.erroRatio = 0.5;
    FalseData.maxErroRatio = 1.5;
    FalseData.erroRatioStep = 0.05;
    FalseData.augDir = 1;
    FalseData.highV = 1.05;
    FalseData.lowV = 0.98;
    %%%%%%%%%%%%%put a false attack element into config structure
    Config.falseDataAttacks = {FalseData}; % target buses

    Config.subAttackSchema = 1; % 1 for no substation attack ; % 2 for substation lost after attacks

    %% create load shape for simulation. even no load shape is used,  keep this code
    if Config.simuType == 0
        cd([pwd, '\loadshape\lf']);
    else
        cd([pwd, '\loadshape\dyn']);
    end
    Config.loadShapeFile = [pwd, '\loadshapeHour'];
    delete *.mat
    createhourloadshape(Config);
    cd(pwdpath);

    %% create case name for record
    caseName = ['baseCase_bus'];

    ResultData = simplePSAT(Config);
    
    ResultData = performanceEvaluation(Config, ResultData);
    
    Ee = [Ee; ResultData.performance.Ee];
    Eq = [Ee; ResultData.performance.Eq];

    cd(pwdpath);

    resultFile = [pwdpath, '/debug/',caseName,'_', startTime];
    save(resultFile, 'Config', 'ResultData');
end
    Eeall = [Eeall, Ee];
    Eqall = [Eqall, Eq];
end

for lagShema = 3: 4
for iBus = 1 : nBus
    bus = PQ(iBus);

    Config = initialConfig;
    %% base case there are no control or attacks
    %% user config for experiment
    Config.verbose = 0; % 0 not output details ; 1 output all logs
    Config.caseName = 'd_039ieee.m'; % case name for psat simulator
    Config.opfCaseName = 'case39'; % case name for the matpower4.1
    Config.simuType = 0; % 0 for pf based , 1 for transient model based
    Config.simuEndTime = 24*3600; % seconds based simulation time, 5*60 means 5 min;
    Config.controlPeriod = 3*60; % seconds based control interval, 2*60 means 2 min;
    Config.sampleRate  = 10; % secnods based sample rate for all measurements;
    Config.enableOPFCtrl = 1; % opf control should be used for this control;
    Config.enableLoadShape = 1; % load shape will not enable for this simulation;
    Config.lfTStep = 10; % seconds based time step for lf model driven simulation;
    Config.dynTStep = 0.05; % seconds based time step for dyn model driven simulation;
    Config.seEnable = 0; % 0 disable, 1 enable state estimation;
    Config.measLagSchema = lagShema; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.measAllLatency = 5; % for latency of Config.measAllLatency*Config.DSSStepsize
    Config.measLatencyChagePeriod = [15*3600, 18*3600];
    Config.measLaggedTunnel = [bus];
    Config.measTunnelLatency = [1e6];

    Config.ctrlLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.falseDataSchema = 0; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
    Config.measErroRatio = 0.3; % for the random erro
    %%%%%%%%%%%%%define a false attack element
    FalseData.toBus = 3;
    FalseData.strategy = 4; % for random erro on the pl and ql;
    FalseData.erroRatio = 0.5;
    FalseData.maxErroRatio = 1.5;
    FalseData.erroRatioStep = 0.05;
    FalseData.augDir = 1;
    FalseData.highV = 1.05;
    FalseData.lowV = 0.98;
    %%%%%%%%%%%%%put a false attack element into config structure
    Config.falseDataAttacks = {FalseData}; % target buses

    Config.subAttackSchema = 1; % 1 for no substation attack ; % 2 for substation lost after attacks

    %% create load shape for simulation. even no load shape is used,  keep this code
    if Config.simuType == 0
        cd([pwd, '\loadshape\lf']);
    else
        cd([pwd, '\loadshape\dyn']);
    end
    Config.loadShapeFile = [pwd, '\loadshapeHour'];
    delete *.mat
    createhourloadshape(Config);
    cd(pwdpath);

    %% create case name for record
    caseName = ['baseCase_bus'];

    ResultData = simplePSAT(Config);
    
    ResultData = performanceEvaluation(Config, ResultData);
    
    Ee = [Ee; ResultData.performance.Ee];
    Eq = [Ee; ResultData.performance.Eq];

    cd(pwdpath);

    resultFile = [pwdpath, '/debug/',caseName,'_', startTime];
    save(resultFile, 'Config', 'ResultData');
end
    Eeall = [Eeall, Ee];
    Eqall = [Eqall, Eq];
end

Ee = []; Eq = [];
for iBus = 1 : nBus
    bus = PQ(iBus);

    Config = initialConfig;
    %% base case there are no control or attacks
    %% user config for experiment
    Config.verbose = 0; % 0 not output details ; 1 output all logs
    Config.caseName = 'd_039ieee.m'; % case name for psat simulator
    Config.opfCaseName = 'case39'; % case name for the matpower4.1
    Config.simuType = 0; % 0 for pf based , 1 for transient model based
    Config.simuEndTime = 24*3600; % seconds based simulation time, 5*60 means 5 min;
    Config.controlPeriod = 3*60; % seconds based control interval, 2*60 means 2 min;
    Config.sampleRate  = 10; % secnods based sample rate for all measurements;
    Config.enableOPFCtrl = 1; % opf control should be used for this control;
    Config.enableLoadShape = 1; % load shape will not enable for this simulation;
    Config.lfTStep = 10; % seconds based time step for lf model driven simulation;
    Config.dynTStep = 0.05; % seconds based time step for dyn model driven simulation;
    Config.seEnable = 1; % 0 disable, 1 enable state estimation;
    Config.measLagSchema = 2; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.measAllLatency = 5; % for latency of Config.measAllLatency*Config.DSSStepsize
    Config.measLatencyChagePeriod = [15*3600, 18*3600];
    Config.measLaggedTunnel = [bus];
    Config.measTunnelLatency = [1e6];

    Config.ctrlLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.falseDataSchema = 2; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
    Config.measErroRatio = 0.3; % for the random erro
    %%%%%%%%%%%%%define a false attack element
    FalseData.toBus = bus;
    FalseData.strategy = 4; % for random erro on the pl and ql;
    FalseData.erroRatio = 0.5;
    FalseData.maxErroRatio = 1.5;
    FalseData.erroRatioStep = 0.05;
    FalseData.augDir = 1;
    FalseData.highV = 1.05;
    FalseData.lowV = 0.98;
    %%%%%%%%%%%%%put a false attack element into config structure
    Config.falseDataAttacks = {FalseData}; % target buses

    Config.subAttackSchema = 1; % 1 for no substation attack ; % 2 for substation lost after attacks

    %% create load shape for simulation. even no load shape is used,  keep this code
    if Config.simuType == 0
        cd([pwd, '\loadshape\lf']);
    else
        cd([pwd, '\loadshape\dyn']);
    end
    Config.loadShapeFile = [pwd, '\loadshapeHour'];
    delete *.mat
    createhourloadshape(Config);
    cd(pwdpath);

    %% create case name for record
    caseName = ['baseCase_bus'];

    ResultData = simplePSAT(Config);
    
    ResultData = performanceEvaluation(Config, ResultData);
    
    Ee = [Ee; ResultData.performance.Ee];
    Eq = [Ee; ResultData.performance.Eq];

    cd(pwdpath);

    resultFile = [pwdpath, '/debug/',caseName,'_', startTime];
    save(resultFile, 'Config', 'ResultData');
end
Eeall = [Eeall, Ee];
Eqall = [Eqall, Eq];


Ee = []; Eq = [];
for iBus = 1 : nBus
    bus = PQ(iBus);

    Config = initialConfig;
    %% base case there are no control or attacks
    %% user config for experiment
    Config.verbose = 0; % 0 not output details ; 1 output all logs
    Config.caseName = 'd_039ieee.m'; % case name for psat simulator
    Config.opfCaseName = 'case39'; % case name for the matpower4.1
    Config.simuType = 0; % 0 for pf based , 1 for transient model based
    Config.simuEndTime = 24*3600; % seconds based simulation time, 5*60 means 5 min;
    Config.controlPeriod = 3*60; % seconds based control interval, 2*60 means 2 min;
    Config.sampleRate  = 10; % secnods based sample rate for all measurements;
    Config.enableOPFCtrl = 1; % opf control should be used for this control;
    Config.enableLoadShape = 1; % load shape will not enable for this simulation;
    Config.lfTStep = 10; % seconds based time step for lf model driven simulation;
    Config.dynTStep = 0.05; % seconds based time step for dyn model driven simulation;
    Config.seEnable = 0; % 0 disable, 1 enable state estimation;
    Config.measLagSchema = 2; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.measAllLatency = 5; % for latency of Config.measAllLatency*Config.DSSStepsize
    Config.measLatencyChagePeriod = [15*3600, 18*3600];
    Config.measLaggedTunnel = [bus];
    Config.measTunnelLatency = [1e6];

    Config.ctrlLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
    Config.falseDataSchema = 2; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
    Config.measErroRatio = 0.3; % for the random erro
    %%%%%%%%%%%%%define a false attack element
    FalseData.toBus = bus;
    FalseData.strategy = 4; % for random erro on the pl and ql;
    FalseData.erroRatio = 0.5;
    FalseData.maxErroRatio = 1.5;
    FalseData.erroRatioStep = 0.05;
    FalseData.augDir = 1;
    FalseData.highV = 1.05;
    FalseData.lowV = 0.98;
    %%%%%%%%%%%%%put a false attack element into config structure
    Config.falseDataAttacks = {FalseData}; % target buses

    Config.subAttackSchema = 1; % 1 for no substation attack ; % 2 for substation lost after attacks

    %% create load shape for simulation. even no load shape is used,  keep this code
    if Config.simuType == 0
        cd([pwd, '\loadshape\lf']);
    else
        cd([pwd, '\loadshape\dyn']);
    end
    Config.loadShapeFile = [pwd, '\loadshapeHour'];
    delete *.mat
    createhourloadshape(Config);
    cd(pwdpath);

    %% create case name for record
    caseName = ['baseCase_bus'];

    ResultData = simplePSAT(Config);
    
    ResultData = performanceEvaluation(Config, ResultData);
    
    Ee = [Ee; ResultData.performance.Ee];
    Eq = [Ee; ResultData.performance.Eq];

    cd(pwdpath);

    resultFile = [pwdpath, '/debug/',caseName,'_', startTime];
    save(resultFile, 'Config', 'ResultData');
end
Eeall = [Eeall, Ee];
Eqall = [Eqall, Eq];
save debug/multi Eeall Eqall

