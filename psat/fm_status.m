function fm_status(varargin)
% FM_STATUS display convergence error of the current simulation in
%           the main window
%
% FM_STATUS('init',xmax,colors,styles,faces)
% FM_STATUS('update',values,iteration,err_max)
%
%see also the structure Hdl
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Update:    09-Jul-2003
%Version:   1.0.1
%
%E-mail:    Federico.Milano@uclm.es
%Web-site:  http://www.uclm.es/area/gsee/Web/Federico
%
% Copyright (C) 2002-2013 Federico Milano

global Settings Fig Hdl Theme CPF OPF

persistent handles
persistent status
persistent firstvalue
persistent hdl

if nargin
  routine = varargin{1};
  flag = varargin{2};
else
  return
end

switch routine
 case 'pf'
  check = Settings.status;
 case 'opf'
  check = OPF.show;
 case 'cpf'
  check = CPF.show;
 case 'lib'
  check = Settings.status;
 case 'snb'
  check = Settings.status;
end

if ~(Settings.show && check && Fig.main), return, end

switch flag
 case 'init'

  xmax = varargin{3};
  colors = varargin{4};
  styles = varargin{5};
  faces = varargin{6};
  if nargin > 6
    yrange = varargin{7};
  else
    yrange = [0 1];
  end

  if Hdl.status ~= 0, delete(Hdl.status); end

  hdl = findobj(Fig.main,'Tag','PushClose');
  set(hdl,'String','Stop');
  set(Fig.main,'UserData',1);

  set(0,'CurrentFigure',Fig.main);
  Hdl.status = axes('position',[0.0406 0.1152 0.2537 0.2243]);
  set(Hdl.status, ...
      'Drawmode','fast', ...
      'NextPlot','add', ...
      'Color',Theme.color11, ...
      'Xlim',[1 xmax], ...
      'Ylim',yrange, ...
      'Box','on');
  grid('on')

  handles = zeros(length(colors),1);
  for i = 1:length(colors)
    handles(i) = line('color',colors{i}, ...
                      'LineStyle',styles{i}, ...
                      'Marker','o', ...
                      'markersize',5, ...
                      'xdata',[1 1], ...
                      'ydata',[100 100], ...
                      'erase','none', ...
                      'MarkerFaceColor',faces{i});
  end
  drawnow
  status = [];

 case 'update'

  values = varargin{3};
  iteration = varargin{4};

  if iteration == 1
    firstvalue = values(2:end);
    if ~firstvalue, firstvalue = 1; end
    values(2:end) = 1;
  else
    values(2:end) = abs(values(2:end))./firstvalue;
  end

  status = [status; values];

  for i = 1:length(handles)
    if status(1,i+1) == 0
      status(1,i+1) = 1;
    end
    set(handles(i), ...
        'xdata',status([max(end-1,1),end],1), ...
        'ydata',status([max(end-1,1),end],i+1));
  end
  drawnow

 case 'close'

  set(hdl,'String','Close');

end