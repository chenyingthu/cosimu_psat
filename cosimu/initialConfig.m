function Config = initialConfig

Config.simuTime = 60*60/0.05;
Config.simuNHour = 24;
Config.basedir = [pwd, '\'];
Config.debugdir = [pwd, '\debug\'];
Config.caseFileDir = [pwd, '\psat\tests'];
Config.caseName = 'd_014_dyn_l14_mdl.m';
Config.sampleRate  = 10;
Config.controlPeriod = 5*60;
Config.opfCaseName = 'case14';
Config.limitControlled = 0;
Config.loadShapeFile = [pwd, '\loadshape\loadshapeHour'];
Config.enableOPFCtrl = 1;
Config.enableLoadShape = 1;
Config.simuType = 0; % 0 for pf based , 1 for transient based
Config.lfTStep = 10;
Config.dynTStep = 0.05;

% Config.opt = mpoption('VERBOSE',0, 'OUT_ALL', 0);
Config.opt = mpoption('VERBOSE',0, 'OUT_ALL', 0, 'OPF_ALG', 580);

Config.num_pts = 28800;

Config.vSrcIdx = 1;
Config.loadshape = 'loadshape2';
Config.loadmult = 1.0;
%% for state estimation
Config.seEnable = 1;

%% for communications and controls
Config.measLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
Config.measAllLatency = 5; % for latency of Config.measAllLatency*Config.DSSStepsize 
Config.measLaggedTunnel = 1 : 1 : 30;
Config.measTunnelLatency = zeros(size(Config.measLaggedTunnel));
Config.ctrlAllLatency = 0; % for latency of Config.ctrlAllLatency
Config.ctrlTGap = 0.1; % control time within current time +/- ctrlTGap => ctrl operation  

Config.genSetpointType = 2; % 1 for v ; 2 for q

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%for bad data injection%%%%%%%%%%%%%%%%%%%
Config.falseDataSchema = 1; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy
Config.measErroRatio = 2; % for the random erro 
%%%%%%%%%%%%%define a false attack element
FalseData.toBus = 1:30;
FalseData.strategy = 4; % for random erro on the pl and ql; 
FalseData.erroRatio = 0.8; 
FalseData.maxErroRatio = 1.5; 
FalseData.erroRatioStep = 0.05; 
FalseData.augDir = 1;
FalseData.highV = 1.05;
FalseData.lowV = 0.98;
%%%%%%%%%%%%%put a false attack element into config structure
Config.falseDataAttacks = {FalseData}; % target buses


%% for load shedding
Config.vLow4Normal = 0.95;
Config.vHigh4Normal = 1.07;
Config.vLow4LoadShed = 0.85;
Config.vHigh4LoadShed = 1.5;
Config.vLow4LoadBack = 0.9;
Config.vHigh4LoadBack = 1.5;
Config.vShedSample = 4;
Config.vRecoverSample = 4;


%% for performance evaluation

Config.normalEPrice = 0.5;
Config.badQosPenaltyPrice = 0.8;
Config.loadShedPenaltyPrice = 2.5;

