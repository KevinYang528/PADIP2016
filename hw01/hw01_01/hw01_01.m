function varargout = hw01_01(varargin)
% HW01_01 MATLAB code for hw01_01.fig
%      HW01_01, by itself, creates a new HW01_01 or raises the existing
%      singleton*.
%
%      H = HW01_01 returns the handle to a new HW01_01 or the handle to
%      the existing singleton*.
%
%      HW01_01('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HW01_01.M with the given input arguments.
%
%      HW01_01('Property','Value',...) creates a new HW01_01 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hw01_01_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hw01_01_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hw01_01

% Last Modified by GUIDE v2.5 07-Oct-2016 11:21:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hw01_01_OpeningFcn, ...
                   'gui_OutputFcn',  @hw01_01_OutputFcn, ...
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


% --- Executes just before hw01_01 is made visible.
function hw01_01_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hw01_01 (see VARARGIN)

% Choose default command line output for hw01_01
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hw01_01 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hw01_01_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = uigetfile({'*.64*','.64 files'});	

fid = fopen( filename, 'r');

% 讀取檔案，為 64*64 char
for i = 1:64
     for j = 1:64
         F(i, j) = fscanf(fid, '%c\n', 1);
     end
end
 
% char 轉換成 ASCII code，0~9一組、A~V一組，
% 可以對照32位元和ASCII，產生兩組規律
I = uint8(F);
for i = 1:64
     for j = 1:64
        % 0~9
        if I(i, j) >= 48 &&  I(i, j) <= 57
            I(i, j) = I(i, j) - 48;
        % 10~31
        elseif I(i, j) >= 65 &&  I(i, j) <= 86
            I(i, j) = I(i, j) - 55;     
        end
        if I(i, j) > 31
            I(i, j) = 31;
        end
    end
end

% histogram
H = zeros(1, 32);
for i = 1:64
    for j = 1:64
        H( I(i, j)+1 ) =   H( I(i, j)+1 ) + 1;
    end
end

% imshow,  histogram plot
axes(handles.axes1); imshow(I*8);            
x = 0:31;
axes(handles.axes2); bar(x, H, 'FaceColor', [0 0 0], 'BarWidth', 1);

fclose(fid);
