function varargout = cosimugui(varargin)
% COSIMUGUI MATLAB code for cosimugui.fig
%      COSIMUGUI, by itself, creates a new COSIMUGUI or raises the existing
%      singleton*.
%
%      H = COSIMUGUI returns the handle to a new COSIMUGUI or the handle to
%      the existing singleton*.
%
%      COSIMUGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in COSIMUGUI.M with the given input arguments.
%
%      COSIMUGUI('Property','Value',...) creates a new COSIMUGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before cosimugui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to cosimugui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help cosimugui

% Last Modified by GUIDE v2.5 28-Feb-2014 10:28:56

% Begin initialization code - DO NOT EDIT


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @cosimugui_OpeningFcn, ...
                   'gui_OutputFcn',  @cosimugui_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before cosimugui is made visible.
function cosimugui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to cosimugui (see VARARGIN)

% Choose default command line output for cosimugui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
cd ..
addpath([pwd, '\coSimu']);
addpath([pwd, '\psat']);
addpath([pwd, '\psat\filters']);
addpath([pwd, '\matpower4.1']);
addpath([pwd, '\matpower4.1\extras\se']);
addpath([pwd, '\debug']);
addpath([pwd, '\loadshape']);

cd gui




% UIWAIT makes cosimugui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = cosimugui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function caseNameEdt_Callback(hObject, eventdata, handles)
% hObject    handle to caseNameEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of caseNameEdt as text
%        str2double(get(hObject,'String')) returns contents of caseNameEdt as a double


% --- Executes during object creation, after setting all properties.
function caseNameEdt_CreateFcn(hObject, eventdata, handles)
% hObject    handle to caseNameEdt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in runBtn.
function runBtn_Callback(hObject, eventdata, handles)
% hObject    handle to runBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd ..
pwdpath = pwd;
Config = initialConfig;

if Config.simuType == 0
    cd([pwd, '\loadshape\lf']);    
else
    cd([pwd, '\loadshape\dyn']);    
end
Config.loadShapeFile = [pwd, '\loadshapeHour'];
delete *.mat
createhourloadshape(Config);

cd(pwdpath);
caseName = ['psat_simu_', num2str(Config.simuNHour)];
startTime =  strrep(strrep(datestr(now), ':', '-'), ' ', '-');
disp([caseName, 'started at ', startTime]);

% caseName = get(handles.caseNameEdt, 'string');

% --- Get all config set based on input of the gui
