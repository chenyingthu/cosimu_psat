function ResultData = initialResultData(Config, CurrentStatus)

global Fig Settings Snapshot Hdl
global Bus File DAE Theme OMIB
global SW PV PQ Fault Ind Syn
global Varout Breaker Line Path clpsat

ResultData.allPLoadHis = [];
ResultData.allQLoadHis = [];
ResultData.allLineHeadPHis = [];
ResultData.allLineHeadQHis = [];
ResultData.allLineTailPHis = [];
ResultData.allLineTailQHis = [];

% record all p q of gens
ResultData.allPGenHis = [];
ResultData.allQGenHis = [];

% p loss & all bus V
ResultData.allBusVHis = [];
ResultData.pLossHis = [];

ResultData.pLForCtrlHis = [];
ResultData.qLForCtrlHis = [];
ResultData.pGenCtrlHis = [];
ResultData.qGenCtrlHis = [];
ResultData.vGenCtrlHis = [];
ResultData.tCtrlHis = [];
ResultData.t = [];
ResultData.ctrlQueue = [];
ResultData.nSample = 0;
ResultData.nOpf = 0;

ResultData.allLoadIdx = [];
busIdx = PQ.bus;
for iBus = 1 : PQ.n
    idx = find(CurrentStatus.bus(:,1) == busIdx(iBus));
    ResultData.allLoadIdx = [ResultData.allLoadIdx; idx];
end

ResultData.loadBase = CurrentStatus.loadBase(ResultData.allLoadIdx, :)/100;

ResultData.allBusIdx = Bus.int;

ResultData.allGenIdx = [];
synIdx = [];
if Config.simuType == 0
    synIdx = [SW.bus; PV.bus];
else
    synIdx = Syn.bus;
end
for iGen = 1 : length(synIdx)
    idx = find(CurrentStatus.gen(:,1) == synIdx(iGen));
    ResultData.allGenIdx = [ResultData.allGenIdx; idx];
end
