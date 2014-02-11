function fm_write(Matrix,Header,Cols,Rows)
% FM_WRITE chose function for writing PSAT outputs
%
%Author:    Federico Milano
%Date:      01-May-2006
%Version:   1.0.0
%
%E-mail:    Federico.Milano@uclm.es
%Web-site:  http://www.uclm.es/area/gsee/Web/Federico
%
% Copyright (C) 2002-2013 Federico Milano

global Settings

% determining the output file name
filename = [fm_filenum(Settings.export),['.',Settings.export]];

% select function for writing outputs
switch Settings.export
 case 'txt'
  fm_writetxt(Matrix,Header,Cols,Rows,filename)
 case 'xls'
  fm_writexls(Matrix,Header,Cols,Rows,filename)
 case 'tex'
  fm_writetex(Matrix,Header,Cols,Rows,filename)
 case 'html'
  fm_writehtm(Matrix,Header,Cols,Rows,filename)
end