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
Config.measLaggedTunnel = [3];
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
Config.falseDataAttacks = {FalseData}; % target buses
% 
% 
% MultiRunConfig.ConfigName = {'seEnable', 'measLagSchema', 'measLaggedTunnel'};
% MultiRunConfig.ConfigValue = cell(size(MultiRunConfig.ConfigName));
% 
% 
% seEnable = [0,1]';
% measLagSchema = [3]';
% measLaggedTunnel = [3     4     7     8    12    15    16    18    20    21    23    24    25    26    27    28    29]';
% 
% MultiRunConfig.ConfigValue{1} = seEnable;
% MultiRunConfig.ConfigValue{2} = measLagSchema;
% MultiRunConfig.ConfigValue{3} = measLaggedTunnel;
% 
% 
% experimentName = ['case39_dos2bus',];
% 
% dstFilePath = [pwd, '\debug\', experimentName, '\'];
% 
% 
% [nCase, caseConfigs ] = MultiRunCoSimu(Config, MultiRunConfig, dstFilePath);
% cd(pwdpath);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MultiRunConfig.ConfigName = {'seEnable', 'falseDataSchema', 'falseDataAttacks{1}.toBus'};
MultiRunConfig.ConfigValue = cell(size(MultiRunConfig.ConfigName));


seEnable = [0,1]';
falseDataSchema = [2]';
toBus = [3     4     7     8    12    15    16    18    20    21    23    24    25    26    27    28    29]';

MultiRunConfig.ConfigValue{1} = seEnable;
MultiRunConfig.ConfigValue{2} = falseDataSchema;
MultiRunConfig.ConfigValue{3} = toBus;


experimentName = ['case39_fd2bus',];

dstFilePath = [pwd, '\debug\', experimentName, '\'];


[nCase, caseConfigs ] = MultiRunCoSimu(Config, MultiRunConfig, dstFilePath);
cd(pwdpath);