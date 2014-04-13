% load debug/39_base_case
% ploss_no_ctl = ResultData.pLossHis';


load debug/baseCase_optCtrl
ploss_ctl = ResultData.pLossHis';

load debug/baseCase_optCtrl_bus3_dos
ploss_ctl_bus3_dos = ResultData.pLossHis';

load debug/baseCase_optCtrl_bus3_3hour_dos
ploss_ctl_3hour_dos = ResultData.pLossHis';

load debug/baseCase_optCtrl_bus3_dos_nose
ploss_ctl_bus3_dos_nose = ResultData.pLossHis';


load debug/baseCase_optCtrl_bus3_3h_dos_nose
ploss_ctl_bus3_3h_dos_nose = ResultData.pLossHis';


load debug/baseCase_optCtrl_bus39_dos_nose
ploss_ctl_bus39_dos_nose = ResultData.pLossHis';

load debug/baseCase_optCtrl_bus39_3h_dos_nose
ploss_ctl_bus39_3h_dos_nose = ResultData.pLossHis';

load debug/baseCase_optCtrl_bus3_fd_nose
ploss_ctl_bus3_fd_nose = ResultData.pLossHis';


load debug/baseCase_optCtrl_bus3_fd_se
ploss_ctl_bus3_fd_se = ResultData.pLossHis';

% load debug/baseCase_opfCtrl_bus3_lag10
% ploss_ctl_b3_lag10 = ResultData.pLossHis';

% load debug/baseCase_optCtl_bus3_lagInf
% ploss_ctl_b3_lagInf = ResultData.pLossHis';

% load debug/baseCase_opfCtrl_bus3_falseData
% ploss_ctl_b3_fd = ResultData.pLossHis';

% y = [ploss_no_ctl; ploss_ctl ; ploss_ctl_b3_lag10; ploss_ctl_b3_lagInf; ploss_ctl_b3_fd];
x = ResultData.t;
y = [ploss_ctl; ploss_ctl_bus3_dos; ploss_ctl_3hour_dos; ploss_ctl_bus3_dos_nose; ...
    ploss_ctl_bus3_3h_dos_nose; ploss_ctl_bus39_dos_nose; ploss_ctl_bus39_3h_dos_nose; ...
    ploss_ctl_bus3_fd_nose; ploss_ctl_bus3_fd_se];
% M = {'no Opfctl', 'Opf Ctrl', 'OpfCtrl bus3 lag10s', 'OpfCtl bus3
% lagInf', 'OpfCtrl bus3 falsedata'};
M = {'normal Opfctl', 'baseCase optCtrl bus3 dos' 'ploss ctl bus3 3hour dos', 'baseCase optCtrl bus3 dos nose', 'baseCase optCtrl bus3 3h dos nose', ...
    'baseCase optCtrl bus39 dos nose', 'baseCase optCtrl bus39 3h dos nose', 'baseCase optCtrl bus3 fd nose', 'baseCase optCtrl bus3 fd se'};
plot(x,y);
legend(M);
xlabel('time(s)');
ylabel('ploss(PU)');
grid