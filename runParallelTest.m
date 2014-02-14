clear;
addpath([pwd, '\coSimu']);
addpath([pwd, '\psat']);
addpath([pwd, '\psat\filters']);
addpath([pwd, '\matpower4.1']);
addpath([pwd, '\matpower4.1\extras\se']);
addpath([pwd, '\debug']);
addpath([pwd, '\tests']);
addpath([pwd, '\loadshape']);
pwdstr = pwd;

parpool(2)
spmd
  % build magic squares in parallel
  testBadDataInjectionMulti(labindex);
end