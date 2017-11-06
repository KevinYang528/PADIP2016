function varargout = HW02(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HW02_OpeningFcn, ...
                   'gui_OutputFcn',  @HW02_OutputFcn, ...
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



function HW02_OpeningFcn(hObject, eventdata, handles, varargin)

handles.w = 0;
w = num2str(handles.w);
set(handles.edit1,'string', w);
set(handles.edit1, 'Max', 9);

handles.output = hObject;
guidata(hObject, handles);



function varargout = HW02_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function pushbutton1_Callback(hObject, eventdata, handles)

filename = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files'});	
handles.I = imread(filename);

[handles.row, handles.col, handles.lay] = size(handles.I);

if handles.lay == 1
    handles.I_gray = handles.I;
    fprintf('gray image\n');
elseif handles.lay == 3
    handles.R = uint8(handles.I(:, :, 1));
    handles.G = uint8(handles.I(:, :, 2));
    handles.B = uint8(handles.I(:, :, 3));
    handles.I_gray = 0.299*handles.R + 0.587*handles.G + 0.114*handles.B;
    fprintf('color image\n');
end

axes(handles.axes1);
imshow(handles.I_gray);

handles.output = hObject;
guidata(hObject, handles);



function radiobutton1_Callback(hObject, eventdata, handles)

set(handles.radiobutton1, 'Value', 1);
set(handles.radiobutton2, 'Value', 0);

w(hObject, eventdata, handles);



function radiobutton2_Callback(hObject, eventdata, handles)

set(handles.radiobutton1, 'Value', 0);
set(handles.radiobutton2, 'Value', 1);

w(hObject, eventdata, handles);



function radiobutton4_Callback(hObject, eventdata, handles)

set(handles.radiobutton4, 'Value', 1);
set(handles.radiobutton5, 'Value', 0);
set(handles.radiobutton6, 'Value', 0);

w(hObject, eventdata, handles);



function radiobutton5_Callback(hObject, eventdata, handles)

set(handles.radiobutton4, 'Value', 0);
set(handles.radiobutton5, 'Value', 1);
set(handles.radiobutton6, 'Value', 0);

w(hObject, eventdata, handles);



function radiobutton6_Callback(hObject, eventdata, handles)

set(handles.radiobutton4, 'Value', 0);
set(handles.radiobutton5, 'Value', 0);
set(handles.radiobutton6, 'Value', 1);

w(hObject, eventdata, handles);


function w(hObject, eventdata, handles)
% Laplacian 3x3
if handles.radiobutton1.Value == 1 && handles.radiobutton4.Value == 1
    handles.w = [0 1 0
                 1 -4 1
                 0 1 0];
% Sobel_x 3x3         
elseif handles.radiobutton1.Value == 1 && handles.radiobutton5.Value == 1
    handles.w = [1 0 -1
                 2 0 -2
                 1 0 -1];
% Smoothing 3x3
elseif handles.radiobutton1.Value == 1 && handles.radiobutton6.Value == 1
    handles.w = [1 1 1
                 1 1 1
                 1 1 1];
% Laplacian 5x5             
elseif handles.radiobutton2.Value == 1 && handles.radiobutton4.Value == 1
    handles.w = [0 0 1 0 0
                 0 1 2 1 0
                 1 2 -16 2 1
                 0 1 2 1 0
                 0 0 1 0 0];
% Sobel_x 5x5
elseif handles.radiobutton2.Value == 1 && handles.radiobutton5.Value == 1
    handles.w = [1 2 0 -2 -1
                 4 8 0 -8 -4
                 6 12 0 -12 -6
                 4 8 0 -8 -4
                 1 2 0 -2 -1];
% Smoothing 5x5             
elseif handles.radiobutton2.Value == 1 && handles.radiobutton6.Value == 1
    handles.w = [1 1 1 1 1
                 1 1 1 1 1
                 1 1 1 1 1 
                 1 1 1 1 1
                 1 1 1 1 1];

end
w = num2str(handles.w);
set(handles.edit1,'String', w);

handles.output = hObject;
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)



function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pushbutton2_Callback(hObject, eventdata, handles)

handles.w = get(handles.edit1, 'String');
handles.w = str2num(handles.w);

% time start
timer1=tic;

% p隨mask的大小改變，例如: 3x3 => p = 1, 5x5 => p = 2
p = ( size(handles.w, 1) - 1 ) / 2;

% smoothing 的分母
N = sum(sum(handles.w));
if N == 0
    N = 1;
end

I3 = double(zeros(handles.row+2*p, handles.col+2*p));
I3(1 + p:handles.row + p, 1 + p:handles.col + p) = handles.I_gray;
I4 = double(zeros(handles.row, handles.col));

for x = 1+p:handles.row+p
    for y = 1+p:handles.col+p
        a = 1;
        for m = x-p:x+p
            b = 1;
            for n = y-p:y+p
%               將mask裡面的數全部加起來
                I4(x-p, y-p) = I4(x-p, y-p) + round( handles.w(a, b)*I3(m, n)/N );
                b = b+1;
            end
            a = a+1;
        end
    end
end
I4 = uint8(I4);
axes(handles.axes1); imshow(I4);

% time end
set(handles.text2, 'String', ['Overall time =', num2str( toc(timer1) ), ' sec'] );

handles.output = hObject;
guidata(hObject, handles);



function pushbutton3_Callback(hObject, eventdata, handles)

set(handles.radiobutton1, 'Value', 0);
set(handles.radiobutton2, 'Value', 0);
set(handles.radiobutton4, 'Value', 0);
set(handles.radiobutton5, 'Value', 0);
set(handles.radiobutton6, 'Value', 0);
handles.w = 0;
w(hObject, eventdata, handles);
set(handles.text2, 'String', 'Overall time :' );

axes(handles.axes1);
imshow(handles.I_gray);
