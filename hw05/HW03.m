function varargout = HW03(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HW03_OpeningFcn, ...
                   'gui_OutputFcn',  @HW03_OutputFcn, ...
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


function HW03_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.edit1, 'String', 2);

handles.output = hObject;
guidata(hObject, handles);


function varargout = HW03_OutputFcn(hObject, eventdata, handles) 

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
function radiobutton1_Callback(hObject, eventdata, handles)

handles.color = cat(3, handles.I(:, :, 1), handles.I(:, :, 2), handles.I(:, :, 3));

handles.output = hObject;
guidata(hObject, handles);


% HSI
function radiobutton2_Callback(hObject, eventdata, handles)

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
H = uint8(H);
S = uint8(S*255);
I = uint8(I*255);

handles.color = cat(3, H, S, I);

handles.output = hObject;
guidata(hObject, handles);


% L*a*b
function radiobutton3_Callback(hObject, eventdata, handles)

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

handles.color = cat(3, L, a, b);

handles.output = hObject;
guidata(hObject, handles);


% Kmeans
function pushbutton2_Callback(hObject, eventdata, handles)

fprintf('Processing...');

X = double(handles.color(:,:,1:3));
[row, col, ~] = size(X);
X = reshape(X, row*col, 3);

n = str2num( get(handles.edit1, 'String') );
% 重複三次分類，避免局部最小值
[cluster_idx, ~] = kmeans(X, n, 'distance', 'sqEuclidean', 'Replicates',3);

pixel_labels = reshape(cluster_idx, row, col);
axes(handles.axes2);
imshow(pixel_labels, []), title('Segmentation result');

fprintf('Done\n');

handles.output = hObject;
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
