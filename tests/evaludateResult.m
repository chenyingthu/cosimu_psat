% evaludate the result
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
dirstr = 'debug/case39_dos2bus';
cd(dirstr);
M = dir;

for i = 1: length(M)
    namestr = M(i).name;
    if strfind(namestr,'seEnable')
        load(namestr);
        ResultData = performanceEvaluation(Config, ResultData);
        save(namestr, 'ResultData');
    end
end