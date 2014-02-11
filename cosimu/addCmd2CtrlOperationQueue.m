function  [ResultData] = addCmd2CtrlOperationQueue(ResultData, Config)

if isempty(ResultData.pGenCtrlHis)
    disp('no control cmd added to queue');
    return
end

latestPCtrl = ResultData.pGenCtrlHis(:, end);
latestQCtrl = ResultData.qGenCtrlHis(:, end);
latestVCtrl = ResultData.vGenCtrlHis(:, end);
ctrlOperation.t = ResultData.tCtrlHis(end);
ctrlOperation.status = 1; % created;
ctrlOperation.target = 'all bus';
ctrlOperation.pGen = latestPCtrl;
ctrlOperation.qGen = latestQCtrl;
ctrlOperation.vGen = latestVCtrl;
ResultData.ctrlQueue = [ResultData.ctrlQueue, ctrlOperation];

end

