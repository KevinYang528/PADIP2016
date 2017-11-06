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

% 設定初始的色調一色調二
set(handles.edit1, 'String', 255);
set(handles.edit2, 'String', 255);
set(handles.edit4, 'String', 0);
set(handles.edit5, 'String', 0);
set(handles.edit6, 'String', 0);
set(handles.edit7, 'String', 255);

handles.output = hObject;
guidata(hObject, handles);


function varargout = HW02_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)

% 讀取圖片
filename = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files'});	
handles.I = imread(filename);

% 轉成灰階
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

handles.output = hObject;
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)


function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(hObject, eventdata, handles)


function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit5_Callback(hObject, eventdata, handles)


function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit6_Callback(hObject, eventdata, handles)


function edit6_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)


function edit7_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function slider1_Callback(hObject, eventdata, handles)


function slider1_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


function pushbutton2_Callback(hObject, eventdata, handles)

r1 = str2num( get(handles.edit1, 'String') );
g1 = str2num( get(handles.edit2, 'String') );
b1 = str2num( get(handles.edit4, 'String') );
r2 = str2num( get(handles.edit5, 'String') );
g2 = str2num( get(handles.edit6, 'String') );
b2 = str2num( get(handles.edit7, 'String') );
num = uint8(get(handles.slider1, 'Value'));

num = double(2^num);
fprintf('num = %d\n', num);

I = handles.I;
[row, col, ~]=size(I);
% num = 2;
bar = zeros(10, 256);
bar2 = zeros(10, 256);
for i = 1:256
    bar2(:,i) = i-1;
end
% r1 = 255; g1 = 0; b1 = 255;
% r2 = 0; g2 = 255; b2 = 255;
% rgb的差值
R = round((r2 - r1)/num);
G = round((g2 - g1)/num);
B = round((b2 - b1)/num);

for n = 1:num
    bound = n*round(255/num);
    fprintf('bound = %d\n', bound);
    for i = 1:row
        for j = 1:col
            % bound:intensity的上邊界，round(255/num):intensity間的距離
            if I(i, j) >= bound-round(255/num) && I(i, j) <= bound 
                % 色調一逐漸加上rgb的差值，變成色調二
                x(i, j, 1) = r1 + (n-1)*R;
                x(i, j, 2) = g1 + (n-1)*G;
                x(i, j, 3) = b1 + (n-1)*B;
            end
        end
    end
    bar(:, bound-255/num:bound+1, 1) = r1 + (n-1)*R;
    bar(:, bound-255/num:bound+1, 2) = g1 + (n-1)*G;
    bar(:, bound-255/num:bound+1, 3) = b1 + (n-1)*B;
end

axes(handles.axes2); imshow(uint8(x));
axes(handles.axes3); imshow(uint8(bar));
axes(handles.axes4); imshow(uint8(bar2));
