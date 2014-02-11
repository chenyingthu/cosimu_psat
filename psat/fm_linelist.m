function fig = fm_linelist()
% FM_LINELIST create GUI for plotted variable lines
%
% HDL = FM_LINELIST()
%
% This function is generally called by a callback within FM_PLOTFIG
%
%Author:    Federico Milano
%Date:      11-Nov-2002
%Version:   1.0.0
%
%E-mail:    Federico.Milano@uclm.es
%Web-site:  http://www.uclm.es/area/gsee/Web/Federico
%
% Copyright (C) 2002-2013 Federico Milano

global Theme

h0 = figure('Color',Theme.color01, ...
	    'Units', 'normalized', ...
	    'Colormap',[], ...
	    'CreateFcn','Fig.line = gcf;', ...
	    'FileName','fm_linelist', ...
	    'DeleteFcn','Fig.line = 0;', ...
	    'MenuBar','none', ...
	    'Name','Line Settings', ...
	    'NumberTitle','off', ...
	    'PaperPosition',[18 180 576 432], ...
	    'PaperUnits','points', ...
	    'Position',sizefig(0.33,0.27), ...
	    'ToolBar','none');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color03, ...
	       'Callback','fm_plot listlines', ...
	       'FontWeight','bold', ...
	       'ForegroundColor',Theme.color04, ...
	       'HitTest','off', ...
	       'ListboxTop',0, ...
	       'Position',[0.096154    0.060714     0.37019     0.13929], ...
	       'String','Edit', ...
	       'Tag','Pushbutton1');
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color02, ...
	       'Callback','close(gcf)', ...
	       'HitTest','off', ...
	       'ListboxTop',0, ...
	       'Position',[0.51923    0.060714     0.37019     0.13929], ...
	       'String','Close', ...
	       'Tag','Pushbutton1');
string = ['if strcmp(get(Fig.line,''SelectionType''),' ...
          '''open''), fm_plot(''listlines''), end'];
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color04, ...
	       'CreateFcn','fm_plot createlinelist', ...
	       'Callback',string, ...
	       'FontName',Theme.font01, ...
	       'ForegroundColor',Theme.color05, ...
	       'HitTest','off', ...
	       'Position',[0.096154     0.26071     0.79327     0.55357], ...
	       'Style','listbox', ...
	       'Tag','Listbox1', ...
	       'Value',1);
h1 = uicontrol('Parent',h0, ...
	       'Units', 'normalized', ...
	       'BackgroundColor',Theme.color01, ...
	       'HitTest','off', ...
	       'HorizontalAlignment','left', ...
	       'ListboxTop',0, ...
	       'Position',[0.096154     0.85357     0.51923    0.071429], ...
	       'String','Lines:', ...
	       'Style','text', ...
	       'Tag','StaticText1');
if nargout > 0, fig = h0; end