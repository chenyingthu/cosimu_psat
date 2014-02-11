Bus.con = [ ... 
  1  69  1.06  0  4  1;
  2  69  1.045  -0.13577  4  1;
  3  69  1.01  -0.33247  4  1;
  4  69  0.99756  -0.26488  4  1;
  5  69  1.0029  -0.22667  4  1;
  6  13.8  1.07  -0.38565  2  1;
  7  13.8  1.0362  -0.34701  2  1;
  8  18  1.09  -0.34701  3  1;
  9  13.8  1.0134  -0.38858  2  1;
  10  13.8  1.0127  -0.39516  2  1;
  11  13.8  1.036  -0.39324  2  1;
  12  13.8  1.0461  -0.40624  2  1;
  13  13.8  1.0367  -0.40667  2  1;
  14  13.8  0.9973  -0.42256  2  1;
 ];

Line.con = [ ... 
  2  5  100  69  60  0  0  0.05695  0.17388  0.034  0  0  0  0  0  1;
  6  12  100  13.8  60  0  0  0.12291  0.25581  0  0  0  0  0  0  1;
  12  13  100  13.8  60  0  0  0.22092  0.19988  0  0  0  0  0  0  1;
  6  13  100  13.8  60  0  0  0.06615  0.13027  0  0  0  0  0  0  1;
  6  11  100  13.8  60  0  0  0.09498  0.1989  0  0  0  0  0  0  1;
  11  10  100  13.8  60  0  0  0.08205  0.19207  0  0  0  0  0  0  1;
  9  10  100  13.8  60  0  0  0.03181  0.0845  0  0  0  0  0  0  1;
  9  14  100  13.8  60  0  0  0.12711  0.27038  0  0  0  0  0  0  1;
  14  13  100  13.8  60  0  0  0.17093  0.34802  0  0  0  0  0  0  1;
  7  9  100  13.8  60  0  0  0  0.11001  0  0  0  0  0  0  1;
  1  2  100  69  60  0  0  0.01938  0.05917  0.0528  0  0  0  0  0  1;
  3  2  100  69  60  0  0  0.04699  0.19797  0.0438  0  0  0  0  0  1;
  3  4  100  69  60  0  0  0.06701  0.17103  0.0346  0  0  0  0  0  1;
  1  5  100  69  60  0  0  0.05403  0.22304  0.0492  0  0  0  0  0  1;
  5  4  100  69  60  0  0  0.01335  0.04211  0.0128  0  0  0  0  0  1;
  2  4  100  69  60  0  0  0.05811  0.17632  0.0374  0  0  0  0  0  1;
  5  6  100  69  60  0  5  0  0.25202  0  0.932  0  0  0  0  1;
  4  9  100  69  60  0  5  0  0.55618  0  0.969  0  0  0  0  1;
  4  7  100  69  60  0  5  0  0.20912  0  0.978  0  0  0  0  1;
  8  7  100  18  60  0  1.304348  0  0.17615  0  0  0  0  0  0  1;
 ];

% Breaker.con = [ ... 
%   16  2  100  69  60  0  100  200;
%  ];

SW.con = [ ... 
  1  100  69  1.06  0  9.9  -9.9  1.2  0.8  2.324  1  1  1;
 ];

PV.con = [ ... 
  2  100  69  0.4  1.045  0.5  -0.4  1.2  0.8  1  1;  
  3  100  69  0  1.01  0.4  0  1.2  0.8  1  1;
  6  100  13.8  0  1.07  0.24  -0.06  1.2  0.8  1  1;
  8  100  18  0  1.09  0.24  -0.06  1.2  0.8  1  1;
 ];

PQ.con = [ ... 
  2  100  69  0.3038  0.1778  1.2  0.8  0  1;
  3  100  69  1.3188  0.266  1.2  0.8  0  1;
  4  100  69  0.6692  0.056  1.2  0.8  0  1;
  5  100  69  0.1064  0.0224  1.2  0.8  0  1;  
  6  100  13.8  0.1568  0.105  1.2  0.8  0  1;
  9  100  13.8  0.413  0.2324  1.2  0.8  0  1;
  10  100  13.8  0.126  0.0812  1.2  0.8  0  1;
  11  100  13.8  0.049  0.0252  1.2  0.8  0  1;
  12  100  13.8  0.0854  0.0224  1.2  0.8  0  1;
  13  100  13.8  0.189  0.0812  1.2  0.8  0  1;  
  14  100  13.8  0.2086  0.07  1.2  0.8  0  1;  
 ];

Syn.con = [ ... 
%   1  615  69  60  5.2  0.2396  0  0.8979  0.2998  0.23  7.4  0.03  0.646  0.646  0.4  0  0.033  10.296  2  0  0  1  1  0  0  0  1  1;
%   2  60  69  60  6  0  0.0031  1.05  0.185  0.13  6.1  0.04  0.98  0.36  0.13  0.3  0.099  13.08  2  0  0  1  1  0  0  0  1  1;
  1  500  69  60  5.2  0.2396  0  0.8979  0.2998  0.23  10.4  0.03  0.646  0.646  0.4  0  0.033  10.296  2  0  0  1  1  0  0  0  1  1;
  2  200  69  60  6  0  0.0031  1.05  0.185  0.13  8.1  0.04  0.98  0.36  0.13  0.3  0.099  13.08  2  0  0  1  1  0  0  0  1  1;
  3  60  69  60  6  0  0.0031  1.05  0.185  0.13  6.1  0.04  0.98  0.36  0.13  0.3  0.099  13.08  2  0  0  1  1  0  0  0  1  1;    
  6  25  13.8  60  6  0.134  0.0041  1.25  0.232  0.12  4.75  0.06  1.22  0.715  0.12  1.5  0.21  10.12  2  0  0  1  1  0  0  0  1  1;
  8  25  18  60  6  0.134  0.0041  1.25  0.232  0.12  4.75  0.06  1.22  0.715  0.12  1.5  0.21  10.12  2  0  0  1  1  0  0  0  1  1;
 ];

Tg.con = [ ... 
  1  1  1  0.02  1.2  0.01  0.2  0.45  0  12  50  1;
  2  1  1  0.02  1.2  0.01  0.2  0.45  0  12  50  1;
 ];

Exc.con = [ ... 
%   1  2  7.32  0  200  0.02  0.002  1  1  0.2  0.001  0.0006  0.9  1;  
%   2  2  4.38  0  20  0.02  0.001  1  1  1.98  0.001  0.0006  0.9  1;
%   3  2  4.38  0  20  0.02  0.001  1  1  1.98  0.001  0.0006  0.9  1;
%   4  2  6.81  1.395  20  0.02  0.001  1  1  0.7  0.001  0.0006  0.9  1;
%   5  2  6.81  1.395  20  0.02  0.001  1  1  0.7  0.001  0.0006  0.9  1;
1  3  5  -5  200  1  1  1  1  0.001  0.01  0.0006  0.9  1; 
2  3  5  -5  200  1  1  1  1  0.001  0.01  0.0006  0.9  1; 
3  3  5  -5  200  1  1  1  1  0.001  0.01  0.0006  0.9  1; 
4  3  5  -5  200  1  1  1  1  0.001  0.01  0.0006  0.9  1; 
5  3  5  -5  200  1  1  1  1  0.001  0.01  0.0006  0.9  1; 

 ];



Bus.names = {... 
  'Bus 01'; 'Bus 02'; 'Bus 03'; 'Bus 04'; 'Bus 05'; 
  'Bus 06'; 'Bus 07'; 'Bus 08'; 'Bus 09'; 'Bus 10'; 
  'Bus 11'; 'Bus 12'; 'Bus 13'; 'Bus 14'};


% % ================================================================================
% % |     Bus Data                                                                 |
% % ================================================================================
% %  Bus      Voltage          Generation             Load          Lambda($/MVA-hr)
% %   #   Mag(pu) Ang(deg)   P (MW)   Q (MVAr)   P (MW)   Q (MVAr)     P        Q   
% % ----- ------- --------  --------  --------  --------  --------  -------  -------
%  opf = [  1  1.060    0.000   128.58      0.00      0       0      1.000  -0.005
%     2  1.050   -2.177    140.00     21.71     21.70     12.70     1.024    0
%     3  1.016  -10.207      0.00     30.04     94.20     19.00     1.107     0
%     4  1.016   -7.971      0       0      47.80     -3.90     1.086   0.004
%     5  1.018   -6.648      0       0       7.60      1.60     1.071   0.006
%     6  1.060  -12.108      0.00     10.13     11.20      7.50     1.072     0
%     7  1.047  -11.085      0       0       0       0      1.087   0.003
%     8  1.060  -11.085      0.00      8.05      0       0      1.087     0
%     9  1.044  -12.716      0       0      29.50     16.60     1.087   0.005
%    10  1.039  -12.899      0       0       9.00      5.80     1.090   0.008
%    11  1.046  -12.636      0       0       3.50      1.80     1.085   0.006
%    12  1.045  -12.973      0       0       6.10      1.60     1.089   0.006
%    13  1.040  -13.044      0       0      13.50      5.80     1.095   0.010
%    14  1.024  -13.881      0       0      14.90      5.00     1.114   0.015];
% %                         --------  --------  --------  --------
% for iPQ = 1 : length(PQ.con(:,1))
%     idxPQ = find(opf(:,1) == PQ.con(iPQ, 1));
%     PQ.con(iPQ,[4,5]) = opf(idxPQ, [6,7])/100;
% end
% 
% for iPV = 1 : length(PV.con(:,1))
%     idxPV = find(opf(:,1) == PV.con(iPV, 1));
%     PV.con(iPV, 4) = opf(idxPV, 4)/100;
%     PV.con(iPV, 5) = opf(idxPV, 2);
% end