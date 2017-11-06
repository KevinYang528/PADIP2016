function varargout = HW01(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HW01_OpeningFcn, ...
                   'gui_OutputFcn',  @HW01_OutputFcn, ...
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


function HW01_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);


function varargout = HW01_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)

% 讀取圖片
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files'});	
handles.I = imread(filename);

% 轉換成灰階影像
[handles.row, handles.col, handles.lay] = size(handles.I);
if handles.lay == 1
    handles.I = handles.I;
    fprintf('1 layers image\n');
elseif handles.lay == 3
    handles.R = uint8(handles.I(:, :, 1));
    handles.G = uint8(handles.I(:, :, 2));
    handles.B = uint8(handles.I(:, :, 3));
    handles.I = 0.299*handles.R + 0.587*handles.G + 0.114*handles.B;
    fprintf('3 layers image\n');
end

axes(handles.axes1); imshow(handles.I);

% 顯示圖片大小
row = size(handles.I, 1);
col = size(handles.I, 2);
set(handles.text2, 'String', ['Image size : ', num2str( row )...
    ,' x ',num2str( col ) ] );

handles.output = hObject;
guidata(hObject, handles);


function pushbutton2_Callback(hObject, eventdata, handles)

% time start 計時開始
timer1=tic;

% fourier transform
handles.F = fft2(handles.I);

% time end 顯示時間
set(handles.text3, 'String', ['Overall time =', num2str( toc(timer1) ), ' sec'] );

% 使頻譜容易觀察
F_min = log( 1 + abs( min(min(handles.F)) ) );
F_max = log( 1 + abs( max(max(handles.F)) ) );
G = 255;
Y = G*( log(1+abs(handles.F)) - F_min )/( F_max - F_min );
Y = uint8(Y);
Y_shift = fftshift(Y);

axes(handles.axes2); imshow(Y_shift);

handles.output = hObject;
guidata(hObject, handles);


function pushbutton3_Callback(hObject, eventdata, handles)

% time start 計時開始
timer1=tic;

% inverse fourier transform
I2 = uint8( ifft2(handles.F) );

% time end 顯示時間
set(handles.text3, 'String', ['Overall time = ', num2str( toc(timer1) ), ' sec'] );

axes(handles.axes2); imshow(I2);

handles.output = hObject;
guidata(hObject, handles);
