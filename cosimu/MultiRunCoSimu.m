function [r, rtConfigs] = MultiRunCoSimu(Config, MultiRunConfig, dstFilePath)

warning off all


% 1. we should define the cross sets of variables used to adjust the config
pwdstr = pwd;

if ~exist(dstFilePath, 'dir')
    mkdir(dstFilePath);
end

diary([dstFilePath,'experiment.log']);

initialCfgFileName = [dstFilePath, 'initialConfigs', '.mat'];
save(initialCfgFileName , 'Config');

n = length(MultiRunConfig.ConfigValue) ;
indexOfConfig = cell(n, 1);
for j = 1 : n
    [r, c] = size(MultiRunConfig.ConfigValue{j});
    indexOfConfig{j} = 1:r;
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
    
    cd(dstFilePath); 
    createhourloadshape(Config);
    cd(pwdstr);
    Config.loadShapeFile = [dstFilePath, 'loadshapeHour'];
    
    
    try
        ResultData = simplePSAT(Config);
        save(fileName,'ResultData');
    catch ME        
        disp(['case NO ', num2str(i), ' failed ============= ']);
        disp(['exception content as']);
        report = getReport(ME)
        lastFailedCaseFile = [Config.debugdir, 'lastFailedCase.txt'];
        fid = fopen(lastFailedCaseFile, 'a');
        fprintf(fid, '%s|%s\n', datestr(now), fileName);
        fclose(fid);
        pause(60)
    end     
    delete([dstFilePath, 'loadshapeHour*.mat']);
end
disp(['end multiRunSim for test ======================']);

diary(off);

end
