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

% 轉成灰階
[handles.row, handles.col, handles.lay] = size(handles.I);

if handles.lay == 1
    handles.I = handles.I;
    fprintf('1 layers image\n');
elseif handles.lay == 3
    R = uint8(handles.I(:, :, 1));
    G = uint8(handles.I(:, :, 2));
    B = uint8(handles.I(:, :, 3));
    handles.I = 0.299*R + 0.587*G + 0.114*B;
    fprintf('3 layers image\n');
end

axes(handles.axes1); imshow(handles.I);

handles.output = hObject;
guidata(hObject, handles);


function pushbutton2_Callback(hObject, eventdata, handles)

% Trapezoidal Transformation
img = handles.I;
[row, col] = size(handles.I);
img_new = zeros(row, col);

for i = 1:row
    for j = 1:col
        new_x = round( 3*i/4 + j*i/(col*row) );
        new_y = round( j+i/4 - j*i/(2*col) );       
        img_new(new_x, new_y) = img(i, j);     
    end
end

axes(handles.axes2); imshow(uint8(img_new));


function pushbutton3_Callback(hObject, eventdata, handles)

% Wavy Transformation
img = handles.I;
[row, col] = size(handles.I);
img_new = zeros(row, col);

for i = 1:row
    for j = 1:col
        new_x = round(j-32*sin( i/32 ));
        new_y = round(i-32*sin( j/32 ));
        if new_x >= 1 && new_x <= row && new_y >= 1 && new_y <= col
            img_new(j, i) = img(new_x, new_y);
        end
    end
end

axes(handles.axes3); imshow(uint8(img_new));


function pushbutton4_Callback(hObject, eventdata, handles)

% Circular Transformation
img = handles.I;
[row, col] = size(handles.I);
img_new = zeros(row, col);

for i = 1:row
    for j = 1:col
        d = sqrt( (row/2)^2-(row/2-i)^2 ); 
        new_x = round( (j-col/2) * col/(d*2) + col/2 );
        new_y = i;
        if new_x >= 1 && new_x <= col && new_y >= 1 && new_y <= col
            img_new(i, j) = img(new_y, new_x);
        end
    end
end

axes(handles.axes4); imshow(uint8(img_new));
