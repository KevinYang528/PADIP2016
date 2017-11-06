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


% 讀取圖片
function pushbutton1_Callback(hObject, eventdata, handles)

filename = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files'});	
handles.I = imread(filename);
handles.RGB_R = handles.I(:, :, 1);
handles.RGB_G = handles.I(:, :, 2);
handles.RGB_B = handles.I(:, :, 3);

axes(handles.axes1); imshow(handles.I);

handles.output = hObject;
guidata(hObject, handles);


% RGB
function pushbutton2_Callback(hObject, eventdata, handles)

handles.I_RGB = cat(3, handles.RGB_R, handles.RGB_G, handles.RGB_B);
axes(handles.axes2); imshow(handles.I_RGB);
axes(handles.axes3); imshow(handles.RGB_R);
axes(handles.axes4); imshow(handles.RGB_G);
axes(handles.axes5); imshow(handles.RGB_B);

handles.output = hObject;
guidata(hObject, handles);


% CMY
function pushbutton3_Callback(hObject, eventdata, handles)

handles.CMY_C = 255 - handles.RGB_R;
handles.CMY_M = 255 - handles.RGB_G;
handles.CMY_Y = 255 - handles.RGB_B;
handles.I_CMY = cat(3, handles.CMY_C, handles.CMY_M, handles.CMY_Y);

axes(handles.axes2); imshow(handles.I_CMY);
axes(handles.axes3); imshow(handles.CMY_C);
axes(handles.axes4); imshow(handles.CMY_M);
axes(handles.axes5); imshow(handles.CMY_Y);

handles.output = hObject;
guidata(hObject, handles);


% HSI
function pushbutton4_Callback(hObject, eventdata, handles)

[row, col, ~] = size(handles.I);

for i = 1:row;
    for j = 1:col;
        r = double(handles.RGB_R(i, j))/255;
        g = double(handles.RGB_G(i, j))/255;
        b = double(handles.RGB_B(i, j))/255;
        theta = acosd( (1/2)*( (r-g) + (r-b) )/( (r-g)^2 + (r-b)*(g-b) )^(1/2) );
        
        if b <= g
            H(i, j) = theta;
        else
            H(i, j) = 360 - theta;
        end
        
        S(i, j) = 1 - 3/(r + g + b)*(min([r, g, b]));
        I(i, j) = 1/3*(r + g + b);
    end
end

% Hue不是灰階，是角度，不用乘以255
H = uint8(H);
S = uint8(S*255);
I = uint8(I*255);

I_HSI = cat(3, H, S, I);

axes(handles.axes2); imshow(I_HSI);
axes(handles.axes3); imshow(H);
axes(handles.axes4); imshow(S);
axes(handles.axes5); imshow(I);

handles.output = hObject;
guidata(hObject, handles);


% XYZ
function pushbutton5_Callback(hObject, eventdata, handles)

handles.XYZ_X = 0.412453 * handles.RGB_R + 0.357580 * handles.RGB_G + 0.180423 * handles.RGB_B;
handles.XYZ_Y = 0.212671 * handles.RGB_R + 0.715160 * handles.RGB_G + 0.072169 * handles.RGB_B;
handles.XYZ_Z = 0.019334 * handles.RGB_R + 0.119193 * handles.RGB_G + 0.950227 * handles.RGB_B;

handles.I_XYZ = cat(3, handles.XYZ_X, handles.XYZ_Y, handles.XYZ_Z);
axes(handles.axes2); imshow(handles.I_XYZ);
axes(handles.axes3); imshow(handles.XYZ_X);
axes(handles.axes4); imshow(handles.XYZ_Y);
axes(handles.axes5); imshow(handles.XYZ_Z);

handles.output = hObject;
guidata(hObject, handles);


% L*a*b
function pushbutton6_Callback(hObject, eventdata, handles)

X = double(0.412453 * handles.RGB_R + 0.357580 * handles.RGB_G + 0.180423 * handles.RGB_B);
Y = double(0.212671 * handles.RGB_R + 0.715160 * handles.RGB_G + 0.072169 * handles.RGB_B);
Z = double(0.019334 * handles.RGB_R + 0.119193 * handles.RGB_G + 0.950227 * handles.RGB_B);

[row, col, ~] = size(handles.I);

xn = 0.9515;
yn = 1;
zn = 1.0886;

for i = 1:row
    for j = 1:col        
        if Y(i,j)/yn > 0.008856;
            L(i,j) = 116*((Y(i,j)/yn)^(1/3)) - 16;
        else
            L(i,j) = 903.3*Y(i,j)/yn;
        end
        
        if X(i,j)/xn > 0.008856 ;
            fx = (X(i,j)/xn)^(1/3);
        else
            fx = 7.787*(X(i,j)/xn) + 16/116;
        end
        
        if Y(i,j)/yn > 0.008856 ;
            fy=(Y(i,j)/yn)^(1/3);
        else
            fy = 7.787*(Y(i,j)/yn) + 16/116;
        end
        
        if Z(i,j)/zn > 0.008856 ;
            fz = (Z(i,j)/zn)^(1/3);
        else
            fz = 7.787*(Z(i,j)/zn) + 16/116;
        end
        
        a(i,j) = 500*(fx-fy);
        b(i,j) = 200*(fy-fz);
    end
end

I_LAB = cat(3, L, a, b);
axes(handles.axes2); imshow(I_LAB);
axes(handles.axes3); imshow(L);
axes(handles.axes4); imshow(a);
axes(handles.axes5); imshow(b);

handles.output = hObject;
guidata(hObject, handles);


% YUV
function pushbutton7_Callback(hObject, eventdata, handles)

handles.YUV_Y = 0.299 * handles.RGB_R + 0.587 * handles.RGB_G + 0.114 * handles.RGB_B;
handles.YUV_U = 128 - 0.168736 * handles.RGB_R - 0.331264 * handles.RGB_G + 0.5 * handles.RGB_B;
handles.YUV_V = 128 + 0.5 * handles.RGB_R - 0.418688 * handles.RGB_G - 0.081312 * handles.RGB_B;
handles.I_YUV = cat(3, handles.YUV_Y, handles.YUV_U, handles.YUV_V);

axes(handles.axes2); imshow(handles.I_YUV);
axes(handles.axes3); imshow(handles.YUV_Y);
axes(handles.axes4); imshow(handles.YUV_U);
axes(handles.axes5); imshow(handles.YUV_V);

handles.output = hObject;
guidata(hObject, handles);
