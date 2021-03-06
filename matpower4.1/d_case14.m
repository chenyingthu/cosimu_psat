% 02/12/14 File data originated from Matpower data file
% 

Bus.con = [ ...
      1        1     1.06        0    1    1;
      2        1    1.045 -0.08692    1    1;
      3        1     1.01   -0.222    1    1;
      4        1    1.019  -0.1803    1    1;
      5        1     1.02  -0.1532    1    1;
      6        1     1.07  -0.2482    1    1;
      7        1    1.062  -0.2334    1    1;
      8        1     1.09  -0.2332    1    1;
      9        1    1.056  -0.2608    1    1;
     10        1    1.051  -0.2635    1    1;
     11        1    1.057  -0.2581    1    1;
     12        1    1.055   -0.263    1    1;
     13        1     1.05  -0.2646    1    1;
     14        1    1.036    -0.28    1    1;
   ];

SW.con = [ ...
      1      100        1     1.06        0        1        0     1.06     0.94    2.324 1 1  1;
   ];

PV.con = [ ...
   2      100        1      0.4    1.045      0.8     -0.4     1.06     0.94 1  1;
   3      100        1        0     1.01        1       -1     1.06     0.94 1  1;
   6      100        1        0     1.07        1       -1     1.06     0.94 1  1;
   8      100        1        0     1.09        1       -1     1.06     0.94 1  1;
   ];

PQ.con = [ ...
   2 100        1    0.217    0.127     1.06     0.94 0 1;
   3 100        1    0.942     0.19     1.06     0.94 0 1;
   4 100        1    0.478   -0.039     1.06     0.94 0 1;
   5 100        1    0.076    0.016     1.06     0.94 0 1;
   6 100        1    0.112    0.075     1.06     0.94 0 1;
   9 100        1    0.295    0.166     1.06     0.94 0 1;
  10 100        1     0.09    0.058     1.06     0.94 0 1;
  11 100        1    0.035    0.018     1.06     0.94 0 1;
  12 100        1    0.061    0.016     1.06     0.94 0 1;
  13 100        1    0.135    0.058     1.06     0.94 0 1;
  14 100        1    0.149     0.05     1.06     0.94 0 1;
   7 100        1        0        0     1.06     0.94 0 1;
   ];

Shunt.con = [ ...
   9 100        1 60        0     0.19 1;
   ];

Line.con = [ ...
   1    2 100        1 60 0         0  0.01938  0.05917   0.0528        0        0       99        0        0  1;
   1    5 100        1 60 0         0  0.05403    0.223   0.0492        0        0       99        0        0  1;
   2    3 100        1 60 0         0  0.04699    0.198   0.0438        0        0       99        0        0  1;
   2    4 100        1 60 0         0  0.05811   0.1763    0.034        0        0       99        0        0  1;
   2    5 100        1 60 0         0  0.05695   0.1739   0.0346        0        0       99        0        0  1;
   3    4 100        1 60 0         0  0.06701    0.171   0.0128        0        0       99        0        0  1;
   4    5 100        1 60 0         0  0.01335  0.04211        0        0        0       99        0        0  1;
   4    7 100        1 60 0         1        0   0.2091        0    0.978        0       99        0        0  1;
   4    9 100        1 60 0         1        0   0.5562        0    0.969        0       99        0        0  1;
   5    6 100        1 60 0         1        0    0.252        0    0.932        0       99        0        0  1;
   6   11 100        1 60 0         0  0.09498   0.1989        0        0        0       99        0        0  1;
   6   12 100        1 60 0         0   0.1229   0.2558        0        0        0       99        0        0  1;
   6   13 100        1 60 0         0  0.06615   0.1303        0        0        0       99        0        0  1;
   7    8 100        1 60 0         0        0   0.1762        0        0        0       99        0        0  1;
   7    9 100        1 60 0         0        0     0.11        0        0        0       99        0        0  1;
   9   10 100        1 60 0         0  0.03181   0.0845        0        0        0       99        0        0  1;
   9   14 100        1 60 0         0   0.1271   0.2704        0        0        0       99        0        0  1;
  10   11 100        1 60 0         0  0.08205   0.1921        0        0        0       99        0        0  1;
  12   13 100        1 60 0         0   0.2209   0.1999        0        0        0       99        0        0  1;
  13   14 100        1 60 0         0   0.1709    0.348        0        0        0       99        0        0  1;
   ];

Supply.con = [ ...
   1       100        0        5        0        0        0        1        0        0        0        0  1 0 1;
   2       100        0      1.4        0        0        0        1        0        0        0        0  1 0 1;
   3       100        0        0        0        0        0        1        0        0        0        0  1 0 1;
   6       100        0        0        0        0        0        1        0        0        0        0  1 0 1;
   8       100        0        0        0        0        0        1        0        0        0        0  1 0 1;
   ];

Bus.names = {...
      'Bus 1'; 'Bus 2'; 'Bus 3'; 'Bus 4'; 'Bus 5'; 
      'Bus 6'; 'Bus 7'; 'Bus 8'; 'Bus 9'; 'Bus 10'; 
      'Bus 11'; 'Bus 12'; 'Bus 13'; 'Bus 14'};

