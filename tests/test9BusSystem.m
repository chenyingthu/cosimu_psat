%% test 9 bus 3 machine system;

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

pqBus = [ 5, 7, 9];
bus = pqBus(1);
lagSchema = 3;

Config = initialConfig;
%% base case there are no control or attacks
%% user config for experiment
Config.verbose = 0; % 0 not output details ; 1 output all logs
Config.caseName = 'd_case9Q.m'; % case name for psat simulator
Config.opfCaseName = 'case9Q'; % case name for the matpower4.1
Config.simuType = 0; % 0 for pf based , 1 for transient model based
Config.simuEndTime = 24*3600; % seconds based simulation time, 5*60 means 5 min;
Config.controlPeriod = 3*60; % seconds based control interval, 2*60 means 2 min;
Config.sampleRate  = 10; % secnods based sample rate for all measurements;
Config.enableOPFCtrl = 1; % opf control should be used for this control;
Config.enableLoadShape = 1; % load shape will not enable for this simulation;
Config.lfTStep = 10; % seconds based time step for lf model driven simulation;
Config.dynTStep = 0.05; % seconds based time step for dyn model driven simulation;
Config.seEnable = 1; % 0 disable, 1 enable state estimation;
Config.measLagSchema = lagSchema; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
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
caseName = ['baseCase_9bus_opfctl_bus5_lag10s'];

ResultData = simplePSAT(Config);

ResultData = performanceEvaluation(Config, ResultData);
cd(pwdpath);

save(['debug/', caseName], 'ResultData');