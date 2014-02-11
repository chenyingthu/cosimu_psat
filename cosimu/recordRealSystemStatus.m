function ResultData = recordRealSystemStatus(t,Config, ResultData)
global Fig Settings Snapshot Hdl
global Bus File DAE Theme OMIB
global SW PV PQ Fault Ind Syn
global Varout Breaker Line Path clpsat
% check if it is time for sampling
if abs(t - ResultData.nSample*Config.sampleRate) > Settings.tstep
    return;
end


% get all data into sampled data pool
% get all load data from psat
if Config.simuType == 0
    ResultData.allPLoadHis = [ResultData.allPLoadHis, Bus.Pl(PQ.bus)];
    ResultData.allQLoadHis = [ResultData.allQLoadHis, Bus.Ql(PQ.bus)];
else
    ploadMeas = PQ.P;
    qloadMeas = PQ.Q;
    ResultData.allPLoadHis = [ResultData.allPLoadHis, ploadMeas];
    ResultData.allQLoadHis = [ResultData.allQLoadHis, qloadMeas];
end
%     ResultData.sheddedLoadHis = [ResultData.sheddedLoadHis, ones(size(ploadMeas))];

% for the line power
[plineHead,qlineHead,plineTail,qlineTail,bfr,bto] = fm_flows;
ResultData.allLineHeadPHis = [ResultData.allLineHeadPHis, plineHead];
ResultData.allLineHeadQHis = [ResultData.allLineHeadQHis, qlineHead];
ResultData.allLineTailPHis = [ResultData.allLineTailPHis, plineTail];
ResultData.allLineTailQHis = [ResultData.allLineTailQHis, qlineTail];

if Config.simuType == 0
    % record all p q of gens
    ResultData.allPGenHis = [ResultData.allPGenHis, Bus.Pg([SW.bus;PV.bus])];
    ResultData.allQGenHis = [ResultData.allQGenHis, Bus.Qg([SW.bus;PV.bus])];    
else
    % record all p q of gens
    ResultData.allPGenHis = [ResultData.allPGenHis, DAE.y(Syn.p)];
    ResultData.allQGenHis = [ResultData.allQGenHis, DAE.y(Syn.q)];
end

% p loss & all bus V
plineloss = plineHead + plineTail;
lossesPQ= sum(plineloss);
ResultData.allBusVHis = [ResultData.allBusVHis, DAE.y(Bus.v)];
ResultData.pLossHis = [ResultData.pLossHis; lossesPQ];

ResultData.t = [ResultData.t, t];
ResultData.nSample = ResultData.nSample + 1;
