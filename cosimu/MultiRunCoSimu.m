function [r, rtConfigs] = MultiRunCoSimu(MultiRunConfig, dstFilePath)

warning off all


% 1. we should define the cross sets of variables used to adjust the config
if ~exist(dstFilePath, 'dir')
    mkdir(dstFilePath);
end

diary([dstFilePath,'experiment.log']);

Config = initialConfig;

initialCfgFileName = [dstFilePath, 'initialConfigs', '.mat'];
save(initialCfgFileName , 'Config');

n = length(MultiRunConfig.ConfigValue) ;
indexOfConfig = cell(n, 1);
for j = 1 : n
    indexOfConfig{j} = 1:length(MultiRunConfig.ConfigValue{j});
end
[allM{1:n}] = ndgrid(indexOfConfig{:});
allM = cell2mat(cellfun(@(a)a(:),allM,'un',0));

[r, c] = size(allM);

disp(['start multiRunSim for test 1', ' all result will be stored in ' , dstFilePath]);
disp(['total ', num2str(r), ' cases will be simulated']);
for i = 1 : r
    fileName = dstFilePath;
    for j = 1 : c
        value = num2str(MultiRunConfig.ConfigValue{j}(allM(i,j), :));
        %         disp(['Config.', MultiRunConfig.ConfigName{j}, '=',value,';']);
        eval(['Config.', MultiRunConfig.ConfigName{j}, '= [',value,'];']);
        idx = strfind(MultiRunConfig.ConfigName{j}, '.');
        substr = MultiRunConfig.ConfigName{j};
        if ~isempty(idx)
            substr = MultiRunConfig.ConfigName{j}(idx(end) + 1 : end);
        end

        fileName = [fileName, substr, '_',strrep(strrep(value,'.','-'), ' ', '-'),'_'];
    end
    disp(['case NO ', num2str(i), ' as file name : ', fileName, ' excuting']);
    Config.resultFileName = fileName;
    save(fileName,'Config');
    
    
    try
        ResultData = simplePSAT(Config);
        save(fileName,'ResultData');
    catch
        disp(['case NO ', num2str(i), ' failed ============= ']);
        lastFailedCaseFile = [Config.debugdir, 'lastFailedCase.txt'];
        fid = fopen(lastFailedCaseFile, 'a');
        fprintf(fid, '%s|%s\n', datestr(now), fileName);
        fclose(fid);
        pause(60)
    end     
end
disp(['end multiRunSim for test ======================']);

diary(off);

end
