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

%% user config for experiment
Config.verbose = 1; % 0 not output details ; 1 output all logs
Config.caseName = 'd_039ieee.m'; % case name for psat simulator
Config.opfCaseName = 'case39'; % case name for the matpower4.1
Config.simuType = 1; % 0 for pf based , 1 for transient model based
Config.simuEndTime = 80; % seconds based simulation time, 5*60 means 5 min;
Config.controlPeriod = 6; % seconds based control interval, 2*60 means 2 min;
Config.sampleRate  = 0.1; % secnods based sample rate for all measurements;
Config.enableOPFCtrl = 1; % opf control should be used for this control;
Config.enableLoadShape = 0; % load shape will not enable for this simulation;
Config.lfTStep = 0.1; % seconds based time step for lf model driven simulation;
Config.dynTStep = 0.05; % seconds based time step for dyn model driven simulation;
Config.seEnable = 0; % 0 disable, 1 enable state estimation;
Config.measLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
Config.ctrlLagSchema = 1; %1 for perfect comm with no latency; 2 for same latency for all tunnels; 3 for dif. latency for dif. tunnels;
Config.falseDataSchema = 0; % 0 for no false data  ; 1 for random erro based on white noise ; 2 for special false data strategy

%% user config for the bus attacked
Config.subAttackSchema = 2; % 1 for no substation attack ; % 2 for substation lost after attacks
Config.attackedBus = [18, 17]; % bus list attacked;
Config.attackTime = [5, 10]; % attacked to each bus in seconds

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
caseName = ['psat_simu_', num2str(Config.simuEndTime)];
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
disp([caseName, 'started at ', startTime]);

ResultData = simplePSAT(Config);

cd(pwdpath);

resultFile = [pwdpath, '/debug/',caseName,'_', startTime];
save(resultFile, 'Config', 'ResultData');

%% plot result 
% bus V
busVPlot = [1, 3, 10, 31, 33]; % define the bus you want to plot voltage
for iBus = 1 : length(busVPlot)
    figure(iBus);
    plot(ResultData.t, ResultData.allBusVHis(busVPlot(iBus), :));
    title(['voltage of bus ' , num2str(busVPlot(iBus)) ]);
    grid;
    xlabel(['time(s)']);
    ylabel(['pu']);
    
end
