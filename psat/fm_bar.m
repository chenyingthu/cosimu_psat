function fm_bar(command)
% FM_BAR draws PSAT status bar
%
% FM_BAR(COMMAND)
%
%see also FM_MAIN
%
%Author:    Federico Milano
%Date:      25-Feb-2004
%Version:   1.0.0
%
%E-mail:    Federico.Milano@uclm.es
%Web-site:  http://www.uclm.es/area/gsee/Web/Federico
%
% Copyright (C) 2002-2013 Federico Milano

global Hdl Fig Theme Settings
persistent p1 p2

if ~Fig.main, return, end

if isnumeric(command)
  x1 = command(1);
  x2 = command(2);
  if x1 > 0.95
    command = 'drawend';
  else
    command = 'draw';
  end
  x1 = 0.01+x1*0.98;
  x2 = 0.01+x2*0.98;
end

switch command
 case 'open'

  set(Fig.main,'Pointer','watch')
  set(0,'CurrentFigure',Fig.main);
  set(Hdl.text,'Visible','off');
  set(Hdl.frame,'Visible','off');
  if Hdl.bar ~= 0, delete(Hdl.bar), end
  Hdl.bar = axes('position',[0.04064 0.0358 0.9212 0.04361], ...
                 'box','on');

  set(Hdl.bar, ...
      'Drawmode','fast', ...
      'NextPlot','add', ...
      'Color',[0.9 0.9 0.9], ...
      'Xlim',[0 1], ...
      'Ylim',[0 1], ...
      'Box','on', ...
      'XTick',[], ...
      'YTick',[], ...
      'XTickLabel','', ...
      'YTickLabel','');
  p1 = fill([0.01 0.01 0.01+1e-5 0.01+1e-5],[0.25 0.75 0.75 0.25], ...
             Theme.color08,'EdgeColor',Theme.color08,'EraseMode','none');
  p2 = text(1e-5,0.35,[' ',num2str(round(1e-5*100)),'%']);
  if Settings.hostver >= 7.07
    set(p2,'EraseMode','background','HorizontalAlignment','left');
  else
    set(p2,'EraseMode','xor','HorizontalAlignment','left');
  end
  drawnow

 case 'draw'

  set(p2,'Position',[x1, 0.35, 0], ...
      'String',[' ',num2str(round(x1*100)),'%']);
  set(p2,'Position',[x2, 0.35, 0], ...
      'String',[' ',num2str(round(x2*100)),'%']);
  set(p1,'XData',[0.01, 0.01, x2, x2]);
  drawnow

 case 'drawend'

  set(p2,'Position',[x1, 0.35, 0], ...
         'String',[' ',num2str(round(x1*100)),'%']);
  set(p2,'HorizontalAlignment','right');
  set(p1,'XData',[x1, x1, x2, x2]);
  set(p2,'Position',[x2, 0.35, 0], ...
         'String',[' ',num2str(round(x2*100)),'%']);
  drawnow

 case 'close'

  set(Fig.main,'Pointer','arrow');
  delete(Hdl.bar);
  Hdl.bar = 0;
  set(Hdl.frame,'Visible','on');
  set(Hdl.text,'Visible','on');
  clear p1 p2

end