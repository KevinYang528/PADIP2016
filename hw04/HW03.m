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

handles.output = hObject;
guidata(hObject, handles);


function varargout = HW03_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;


function pushbutton1_Callback(hObject, eventdata, handles)

% 讀取檔案
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


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)

% image processing
rL = str2double( get(handles.edit1, 'String') );
rH = str2double( get(handles.edit2, 'String') );
c = str2double( get(handles.edit3, 'String') );
D0 = str2double( get(handles.edit4, 'String') );

% step1
[M, N] = size(handles.I);
P = 2*M;
Q = 2*N;

% step2
fp = zeros(P, Q);
for i = 1:M
    for j = 1:N
        fp(i, j) = handles.I(i, j);
    end
end

% step3 
for i = 1:M
    for j = 1:N
        fp(i, j) = fp(i, j)*( (-1)^(i+j) );
    end
end

% step4
F = fft2( fp );

% step5
D = zeros(P, Q);
H = zeros(P, Q);
% Homomorphic filter
for i = 1:P
    for j = 1:Q
        D(i, j) = ( (i - P/2)^2 + ( j - Q/2 )^2 )^(1/2);
        H(i, j) = ( rH - rL )*(1 - exp( -c*( (D(i, j))^2 / D0^2 ) )) + rL;        
    end
end

G = H .* F;

% step6
gp = zeros(P, Q);

Gifft = real( ifft2(G) );
for i = 1:P
    for j = 1:Q
        gp(i, j) = ( Gifft(i, j) )*(-1)^(i+j);
    end
end

% step7
g = zeros(M, N);
for i = 1:M
    for j = 1:N
        g(i, j) = gp(i, j);
    end
end

axes(handles.axes1); imshow( uint8(g) );

handles.output = hObject;
guidata(hObject, handles);


function edit1_Callback(hObject, eventdata, handles)


function edit1_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit2_Callback(hObject, eventdata, handles)


function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit3_Callback(hObject, eventdata, handles)


function edit3_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function edit4_Callback(hObject, eventdata, handles)


function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
