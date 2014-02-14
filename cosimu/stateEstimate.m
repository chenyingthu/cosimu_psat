function [baseMVA, bus, gen, branch, success] = stateEstimate(ResultData, CurrentStatus)

%% run state estimator
%% which measurements are available
idx.idx_zPF = [ResultData.allLineIdx];
idx.idx_zPT = [ResultData.allLineIdx];
idx.idx_zPG = [ResultData.allGenIdx];
idx.idx_zVa = [];
idx.idx_zQF = [ResultData.allLineIdx];
idx.idx_zQT = [ResultData.allLineIdx];
idx.idx_zQG = ResultData.allGenIdx;
idx.idx_zVm = ResultData.allBusIdx;

%% specify measurements
measure.PF = [CurrentStatus.plineHeadMeas];
measure.PT = [CurrentStatus.plineTailMeas];
measure.PG = [CurrentStatus.genPMeas];
measure.Va = [];
measure.QF = [CurrentStatus.qlineHeadMeas];
measure.QT = [CurrentStatus.qlineTailMeas];
measure.QG = CurrentStatus.genQMeas;
measure.Vm = CurrentStatus.busVMeasPu;

%% specify measurement variances
sigma.sigma_PF = 0.02;
sigma.sigma_PT = 0.02;
sigma.sigma_PG = 0.015;
sigma.sigma_Va = 0.001;
sigma.sigma_QF = 0.02;
sigma.sigma_QT = 0.02;
sigma.sigma_QG = 0.02;
sigma.sigma_Vm = 0.01;

type_initialguess = 2; 

%% read data & convert to internal bus numbering
baseMVA = CurrentStatus.baseMVA;
bus = CurrentStatus.bus;
gen = CurrentStatus.gen;
branch = CurrentStatus.branch;

[i2e, bus, gen, branch] = ext2int(bus, gen, branch);

%% get bus index lists of each type of bus
[ref, pv, pq] = bustypes(bus, gen);

%% build admittance matrices
[Ybus, Yf, Yt] = makeYbus(baseMVA, bus, branch);
Ybus = full(Ybus);
Yf = full(Yf);
Yt = full(Yt);

%% prepare initial guess
if nargin < 6
    V0 = getV0(bus, gen, type_initialguess);
else
    V0 = getV0(bus, gen, type_initialguess, V0);
end

%% define named indices into bus, gen, branch matrices
[PQ, PV, REF, NONE, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
    VA, BASE_KV, ZONE, VMAX, VMIN, LAM_P, LAM_Q, MU_VMAX, MU_VMIN] = idx_bus;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE_A, RATE_B, RATE_C, ...
    TAP, SHIFT, BR_STATUS, PF, QF, PT, QT, MU_SF, MU_ST, ...
    ANGMIN, ANGMAX, MU_ANGMIN, MU_ANGMAX] = idx_brch;
[GEN_BUS, PG, QG, QMAX, QMIN, VG, MBASE, GEN_STATUS, PMAX, PMIN, ...
    MU_PMAX, MU_PMIN, MU_QMAX, MU_QMIN, PC1, PC2, QC1MIN, QC1MAX, ...
    QC2MIN, QC2MAX, RAMP_AGC, RAMP_10, RAMP_30, RAMP_Q, APF] = idx_gen;

%% run state estimation
t0 = clock;
[V, success, iterNum, z, z_est, error_sqrsum] = doSE(baseMVA, bus, gen, branch, Ybus, Yf, Yt, V0, ref, pv, pq, measure, idx, sigma);
et = etime(clock, t0);

%% update data matrices to match estimator solution ...
%% ... bus injections at PQ buses
Sbus = V .* conj(Ybus * V);
bus(pq, PD) = -real(Sbus(pq)) * baseMVA;
bus(pq, QD) = -imag(Sbus(pq)) * baseMVA;
%% ... gen outputs at PV buses
on = find(gen(:, GEN_STATUS) > 0);      %% which generators are on?
gbus = gen(on, GEN_BUS);                %% what buses are they at?
gen(on, PG) = real(Sbus(gbus)) * baseMVA + bus(gbus, PD);   %% inj P + local Pd
%% ... line flows, reference bus injections, etc. 
%% update data matrices with solution, ie, V
[bus, gen, branch] = pfsoln(baseMVA, bus, gen, branch, Ybus, Yf, Yt, V, ref, pv, pq);



