function testBadDataInjectionMulti(caseGroupNo)
%% test 1 : 
%for the false data schema 1 with different measErroRatio and genSetpointType


MultiRunConfig.ConfigName = {'simuType', 'falseDataSchema', 'falseDataAttacks{1}.toBus', 'falseDataAttacks{1}.strategy', 'falseDataAttacks{1}.erroRatio', 'seEnable'};
MultiRunConfig.ConfigValue = cell(size(MultiRunConfig.ConfigName));

switch caseGroupNo
    case 1  
        simuType = [0]';
        falseDataSchema = [2]';        
        toBus = combntns([2:3], 2);
        toBus = [2:3];
%         toBus = toBus(1:length(toBus)/2, :);
        strategy = [4]';
        erroRatio = [0.5]';
        seEnable = [1]';
    case 2  
        simuType = [1]';
        falseDataSchema = [2]';
        toBus = [2:3];
%         toBus = combntns([2:3], 2);
%         toBus = toBus(length(toBus)/2 + 1 : end, :);
        strategy = [4]';
        erroRatio = [0.1:0.2:1]';
        seEnable = [1]';        
%     case 3
%         simuType = [0]';
%         falseDataSchema = [2]';        
%         toBus = combntns([2:1:14], 2);
%         toBus = toBus(1:length(toBus)/2, :);
%         strategy = [4]';
%         erroRatio = [-1]';
%         seEnable = [1]';
%     case 4
%         simuType = [0]';
%         falseDataSchema = [2]';        
%         toBus = combntns([2:1:14], 2);
%         toBus = toBus(length(toBus)/2 + 1 : end, :);
%         strategy = [4]';
%         erroRatio = [-1]';
%         seEnable = [1]';
%     case 5  
%         simuType = [1]';
%         falseDataSchema = [2]';        
%         toBus = combntns([2:1:14], 2);
%         toBus = toBus(1:length(toBus)/2, :);
%         strategy = [4]';
%         erroRatio = [1]';
%         seEnable = [1]';
%     case 6
%         simuType = [1]';
%         falseDataSchema = [2]';        
%         toBus = combntns([2:1:14], 2);
%         toBus = toBus(length(toBus)/2 + 1 : end, :);
%         strategy = [4]';
%         erroRatio = [1]';
%         seEnable = [1]';
%     case 7
%         simuType = [1]';
%         falseDataSchema = [2]';        
%         toBus = combntns([2:1:14], 2);
%         toBus = toBus(1:length(toBus)/2, :);
%         strategy = [4]';
%         erroRatio = [-1]';
%         seEnable = [1]';
%     case 8
%         simuType = [1]';
%         falseDataSchema = [2]';        
%         toBus = combntns([2:1:14], 2);
%         toBus = toBus(length(toBus)/2 + 1 : end, :);
%         strategy = [4]';
%         erroRatio = [-1]';
%         seEnable = [1]';
%     otherwise
%         simuType = [0, 1]';        
%         genSetpointType = [1,2]';
%         toBus = combntns([2:1:14], 2);
%         strategy = [4]';
%         erroRatio = [-1, 1]';
%         seEnable = [1]';
end
        

% 
MultiRunConfig.ConfigValue{1} = simuType;
MultiRunConfig.ConfigValue{2} = falseDataSchema;
MultiRunConfig.ConfigValue{3} = toBus;
MultiRunConfig.ConfigValue{4} = strategy;
MultiRunConfig.ConfigValue{5} = erroRatio;
MultiRunConfig.ConfigValue{6} = seEnable;

experimentName = ['fdi_2b_group_',num2str(caseGroupNo), strrep(strrep(datestr(now), ':', '-'), ' ', '-')];

dstFilePath = [pwd, '\debug\', experimentName, '\'];


[nCase, caseConfigs ] = MultiRunCoSimu(MultiRunConfig, dstFilePath);
cd(pwdstr);

% MultiRunConfig.ResultCompareName = 'performance.all';
% [caseNames, values_all] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );
% [sorted, idx ] = sort(values_all,  'descend');
% worstCases4All = caseNames(idx(1:10))
% 
% MultiRunConfig.ResultCompareName = 'performance.Eq';
% [caseNames, values_Eq] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );
% [sorted, idx ] = sort(values_Eq,  'descend');
% worstCases4Eq = caseNames(idx(1:10))
% 
% MultiRunConfig.ResultCompareName = 'performance.Ee';
% [caseNames, values_Ee] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );
% [sorted, idx ] = sort(values_Ee,  'descend');
% worstCases4Ee = caseNames(idx(1:10))
% 
% MultiRunConfig.ResultCompareName = 'performance.Es';
% [caseNames, values_Es] = ComparePerformanceofMultiRunTest(MultiRunConfig, dstFilePath );
% [sorted, idx ] = sort(values_Es,  'descend');
% worstCases4Es = caseNames(idx(1:10))

