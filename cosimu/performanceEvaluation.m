function [ResultData] = performanceEvaluation(Config, ResultData)



%% ecomonica performance degeneration
pl = ResultData.pLossHis(2:end);
interval = ones(size(pl))*Config.lfTStep;
ResultData.overallPlossKWH = interval'*pl;



%% qualit performance degeneration
% Config.vLow4Normal = 0.95;
% Config.vHigh4Normal = 1.07;
% Config.vLow4LoadShed = 0.85;
% Config.vHigh4LoadShed = 1.12;
% Config.vLow4LoadBack = 0.9;
% Config.vHigh4LoadBack = 1.1;

badQosLoad = 0;
nLoad = length(ResultData.allPLoadHis(:, 1));
for i = 1 : nLoad
    v = ResultData.allBusVHis(ResultData.allLoadIdx(i), :);
    tIdx = find((v > Config.vLow4LoadShed & v < Config.vLow4Normal) | (v > Config.vHigh4Normal & v < Config.vHigh4LoadShed));
    badQosLoad = badQosLoad + sum(ResultData.allPLoadHis(i, tIdx));
end
ResultData.badQosLoad = badQosLoad*Config.lfTStep;


%% security performance degeneration
% load the perfect load data


sheddedLoad = 0;
% Config.vLow4LoadShed = 0.85;
% Config.vHigh4LoadShed = 1.5;
for i = 1 : nLoad
    v = ResultData.allBusVHis(ResultData.allLoadIdx(i), :);
    tIdx = find((v < Config.vLow4LoadShed) | (v > Config.vHigh4LoadShed));
    sheddedLoad = sheddedLoad + sum(ResultData.allPLoadHis(i, tIdx));
end

ResultData.sheddedLoad = sheddedLoad*Config.lfTStep;

ResultData.performance.Ee = ResultData.overallPlossKWH * Config.normalEPrice; %- ResultData.performance.EeBase;
ResultData.performance.Eq = ResultData.badQosLoad * Config.badQosPenaltyPrice;
ResultData.performance.Es = ResultData.sheddedLoad * Config.loadShedPenaltyPrice;
ResultData.performance.all = ResultData.performance.Ee + ResultData.performance.Eq + ResultData.performance.Es;
                    
% ResultData.performance
end