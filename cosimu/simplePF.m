function simplePF(Config, CurrentStatus)

fm_var
if isempty(File.data)
    fm_disp('Set a data file before running Power Flow.',2)
    return
end

if clpsat.readfile || Settings.init == 0
    fm_inilf
    filedata = [File.data,'  '];
    filedata = strrep(filedata,'@ ','');   
    
    if ~isempty(findstr(filedata,'(mdl)')) && clpsat.refreshsim
      filedata1 = File.data(1:end-5);
      open_sys = find_system('type','block_diagram');
      OpenModel = sum(strcmp(open_sys,filedata1));
      if OpenModel
        if strcmp(get_param(filedata1,'Dirty'),'on') || ...
              str2num(get_param(filedata1,'ModelVersion')) > Settings.mv
          check = sim2psat;
          if ~check, return, end
        end
      end
    end
    
    cd(Path.data)    
    filedata = deblank(strrep(filedata,'(mdl)','_mdl'));
    a = exist(filedata);
    clear(filedata)
    if a == 2,
        b = dir([filedata,'.m']);
        lasterr('');
        %if ~strcmp(File.modify,b.date)
        try
            fm_disp('Load data from file...')
            eval(filedata);
            File.modify = b.date;
        catch
            fm_disp(lasterr),
            fm_disp(['Something wrong with the data file "',filedata,'"']),
            return
        end
        %end
    else
        fm_disp(['File "',filedata,'" not found or not an m-file'],2)
    end
    cd(Path.local)
    Settings.init = 0;
end

%% create an opf based initial snapshot 

load([Config.loadShapeFile, '1']);
loadshape = hourDataNew;
initialLoadRate = loadshape(1);

CurrentStatus.bus(:,[3,4]) = initialLoadRate * CurrentStatus.bus(:,[3,4]);
optresult = runopf(CurrentStatus, Config.opt);

if optresult.success == 1
    for iPQ = 1 : length(PQ.con(:,1))
        idxPQ = find(optresult.bus(:,1) == PQ.con(iPQ, 1));
        PQ.con(iPQ,[4,5]) = (optresult.bus(idxPQ,[3,4]))/100;
    end  
    
    for iPV = 1 : length(PV.con(:,1))
        idxPV = find(optresult.bus(:,1) == PV.con(iPV, 1));
        PV.con(iPV, 5) = optresult.bus(idxPV, 8);
        idxPV = find(optresult.gen(:,1) == PV.con(iPV, 1));
        PV.con(iPV, 4) = optresult.gen(idxPV, 2)/100;
    end
    
else
    disp([' >>>>>>>>>>>>>>>> opf failed for initialLoadRate as ' , num2str(initialLoadRate)]);
end

%%
if Settings.init
    fm_restore
    if Settings.conv, fm_base, end
    Line = build_y(Line);
%     fm_wcall;
    fm_dynlf;
end

filedata = deblank(strrep(File.data,'(mdl)','_mdl'));
if Settings.static % do not use dynamic components
    for i = 1:Comp.n
        comp_name = [Comp.names{i},'.con'];
        comp_con = eval(['~isempty(',comp_name,')']);
        if comp_con && ~Comp.prop(i,6)
            eval([comp_name,' = [];']);
        end
    end
end

% the following code is needed for compatibility with older PSAT versions
if isfield(Varname,'bus')
    if ~isempty(Varname.bus)
        Bus.names = Varname.bus;
        Varname = rmfield(Varname,'bus');
    end
end

if exist('Mot')
    if isfield(Mot,'con')
        Ind.con = Mot.con;
        clear Mot
    end
end

fm_spf_modified(Config);
SNB.init = 0;
LIB.init = 0;
CPF.init = 0;
OPF.init = 0;