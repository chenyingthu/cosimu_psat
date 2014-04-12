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
ResultData.allLoadBusIdx = PQ.bus;
busIdx = PQ.bus;
for iBus = 1 : PQ.n
    idx = find(CurrentStatus.bus(:,1) == busIdx(iBus));
    ResultData.allLoadIdx = [ResultData.allLoadIdx; idx];
end

ResultData.loadBase = CurrentStatus.loadBase(ResultData.allLoadIdx, :)/100;

ResultData.allBusIdx = Bus.int;

ResultData.allGenIdx = [];
ResultData.allGenBusIdx = [];
synIdx = [];
if Config.simuType == 0
    synIdx = [SW.bus; PV.bus];
else
    synIdx = Syn.bus;
end
ResultData.allGenBusIdx = synIdx;
for iGen = 1 : length(synIdx)
    idx = find(CurrentStatus.gen(:,1) == synIdx(iGen));
    ResultData.allGenIdx = [ResultData.allGenIdx; idx];
end

ResultData.allLineIdx = [];
ResultData.allLineHeadBusIdx = [];
ResultData.allLineTailBusIdx = [];

for iLine = 1 : Line.n            
    fromBus = Line.con(iLine, 1);
    endBus = Line.con(iLine, 2);
    idx = find(CurrentStatus.branch(:,1)==fromBus & CurrentStatus.branch(:,2) == endBus);
    if isempty(idx)
        idx = find(CurrentStatus.branch(:,1)==endBus & CurrentStatus.branch(:,2) == fromBus);
    end
    ResultData.allLineIdx = [ResultData.allLineIdx; idx];
    ResultData.allLineHeadBusIdx = [ResultData.allLineHeadBusIdx; find(CurrentStatus.bus(:,1)==fromBus)];
    ResultData.allLineTailBusIdx = [ResultData.allLineTailBusIdx; find(CurrentStatus.bus(:,1)==endBus)];
end





