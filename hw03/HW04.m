function varargout = HW04(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HW04_OpeningFcn, ...
                   'gui_OutputFcn',  @HW04_OutputFcn, ...
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



function HW04_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);



function varargout = HW04_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



function pushbutton1_Callback(hObject, eventdata, handles)

% 原圖
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

% Sobel_x
handles.Sx =  [-1 0 1
               -2 0 2
               -1 0 1];

% p隨mask的大小改變，例如: 3x3 => p = 1, 5x5 => p = 2
p = ( size(handles.Sx, 1) - 1 ) / 2;

I3 = double(zeros(handles.row+2*p, handles.col+2*p));
I3(1 + p:handles.row + p, 1 + p:handles.col + p) = handles.I_gray;
I4 = double(zeros(handles.row, handles.col));

for x = 1+p:handles.row+p
    for y = 1+p:handles.col+p
        a = 1;
        for m = x-p:x+p
            b = 1;
            for n = y-p:y+p
                % 將mask裡面的數全部加起來
                I4(x-p, y-p) = I4(x-p, y-p) + round( handles.Sx(a, b)*I3(m, n) );
                b = b+1;
            end
            a = a+1;
        end
    end
end  
I5 = uint8(I4);

% Sobel_y
handles.Sy =  [-1 -2 -1
               0 0 0
               1 2 1];
% p隨mask的大小改變，例如: 3x3 => p = 1, 5x5 => p = 2
p = ( size(handles.Sy, 1) - 1 ) / 2;

I3 = double(zeros(handles.row+2*p, handles.col+2*p));
I3(1 + p:handles.row + p, 1 + p:handles.col + p) = handles.I_gray;
I4 = double(zeros(handles.row, handles.col));

for x = 1+p:handles.row+p
    for y = 1+p:handles.col+p
        a = 1;
        for m = x-p:x+p
            b = 1;
            for n = y-p:y+p
                % 將mask裡面的數全部加起來
                I4(x-p, y-p) = I4(x-p, y-p) + round( handles.Sy(a, b)*I3(m, n) );
                b = b+1;
            end
            a = a+1;
        end
    end
end  
I6 = uint8(I4);

% Sobel_x + Sobel_y
axes(handles.axes3); imshow(I5+I6);

% Fuzzy sets
I7 = double(zeros(handles.row, handles.col));
for x = 1+p:handles.row+p
    for y = 1+p:handles.col+p
        d = zeros(3);
        a = 1;
        for m = x-p:x+p
            b = 1;
            for n = y-p:y+p
                % intensity difference
                d(a, b) = I3(m, n) - I3(x, y);
                b = b + 1; 
            end
            a = a + 1;
        end
        
        if abs( d(1, 2) ) <= 10 && abs( d(2, 3) ) <= 10
            I7(x-p, y-p) = 0;
        elseif abs( d(2, 3) ) <= 10 && abs( d(3, 2) ) <= 10
            I7(x-p, y-p) = 0;
        elseif abs( d(3, 2) ) <= 10 && abs( d(2, 1) ) <= 10
            I7(x-p, y-p) = 0;
        elseif abs( d(2, 1) ) <= 10 && abs( d(1, 2) ) <= 10
            I7(x-p, y-p) = 0;
        else
            I7(x-p, y-p) = 255;
        end
    end
end

I7 = uint8(I7);
axes(handles.axes2); imshow(I7);
