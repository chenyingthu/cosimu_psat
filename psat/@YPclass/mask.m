function [x,y,s] = mask(a,idx,orient,vals)

x = cell(3,1);
y = cell(3,1);
s = cell(3,1);

x{1} = [-2 22 22 -2 -2];
y{1} = [-1.1 -1.1 1.1 1.1 -1.1];
s{1} = 'k';

x{2} = [0 0 20];
y{2} = [0.8 -0.8 -0.8];
s{2} = 'b';

x{3} = [0:19];
y{3} = [0.3941  0.5030   0.7220   0.3062  ...
        0.1122  0.4433   0.4668   0.0147  ...
        0.6641  0.7241   0.2816   0.2618  ...
        0.7085  0.7839   0.9862   0.4733  ...
        0.9028  0.4511   0.8045   0.8289]-0.2;
s{3} = 'r';
