load debug/39_base_case
ploss_no_ctl = ResultData.pLossHis';


load debug/baseCase_opfctrl
ploss_ctl = ResultData.pLossHis';

load debug/baseCase_opfCtrl_bus3_lag10
ploss_ctl_b3_lag10 = ResultData.pLossHis';

load debug/baseCase_optCtl_bus3_lagInf
ploss_ctl_b3_lagInf = ResultData.pLossHis';

load debug/baseCase_opfCtrl_bus3_falseData
ploss_ctl_b3_fd = ResultData.pLossHis';

y = [ploss_no_ctl; ploss_ctl ; ploss_ctl_b3_lag10; ploss_ctl_b3_lagInf; ploss_ctl_b3_fd];
x = ResultData.t;
M = {'no Opfctl', 'Opf Ctrl', 'OpfCtrl bus3 lag10s', 'OpfCtl bus3 lagInf', 'OpfCtrl bus3 falsedata'};
plot(x,y);
legend(M);
xlabel('time(s)');
ylabel('ploss(PU)');
grid