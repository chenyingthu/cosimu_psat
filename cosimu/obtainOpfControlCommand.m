function [ ResultData, isConverged ] = obtainOpfControlCommand( CurrentStatus, ResultData, Config)

%% using latest meas
CurrentStatus.bus(ResultData.allLoadIdx, 3) = CurrentStatus.ploadMeas * 100;
CurrentStatus.bus(ResultData.allLoadIdx, 4) = CurrentStatus.qloadMeas * 100;
CurrentStatus.bus(ResultData.allBusIdx, 8) = CurrentStatus.busVMeasPu;
CurrentStatus.gen(ResultData.allGenIdx,2) = CurrentStatus.genPMeas * 100;
CurrentStatus.gen(ResultData.allGenIdx,3) = CurrentStatus.genQMeas * 100;


% %% limit the controllablity of the gens
if Config.limitControlled == 1
    CurrentStatus.gen(ResultData.allGenIdx,9) = min(CurrentStatus.genPMeas*1.2*100, CurrentStatus.genControllabilty(ResultData.allGenIdx, 1));
    CurrentStatus.gen(ResultData.allGenIdx,10) = max(CurrentStatus.genPMeas*0.8*100, CurrentStatus.genControllabilty(ResultData.allGenIdx, 2));
end




% %% run state estimation
% % flat start
% if Config.seEnable == 1
%     [baseMVA, bus, gen, branch, se_success] = StateEstimate(ResultData, CurrentStatus);
%     if se_success == 1
%         CurrentStatus.bus = bus;
%         CurrentStatus.branch = branch;
%         CurrentStatus.gen = gen;
%     else
%         disp(['t = ', num2str(ResultData.t(end)),' >>>>>>>>>>>>>>>> se failed']);
%     end
% end


%% run opf
optresult = runopf(CurrentStatus, Config.opt);

%% set opf result back to opendss as control set point
if optresult.success == 1
    ResultData.pLForCtrlHis = [ResultData.pLForCtrlHis, CurrentStatus.ploadMeas];
    ResultData.qLForCtrlHis = [ResultData.qLForCtrlHis, CurrentStatus.qloadMeas];
    ResultData.pGenCtrlHis = [ResultData.pGenCtrlHis, optresult.gen(:, 2)/100];
    ResultData.qGenCtrlHis = [ResultData.qGenCtrlHis, optresult.gen(:, 3)/100];
    ResultData.vGenCtrlHis = [ResultData.vGenCtrlHis, optresult.gen(:, 6)];
    ResultData.tCtrlHis = [ResultData.tCtrlHis, ResultData.t(end)];
else
    disp(['t = ', num2str(ResultData.t(end)),' >>>>>>>>>>>>>>>> opf failed']);
end
isConverged = optresult.success;

end
