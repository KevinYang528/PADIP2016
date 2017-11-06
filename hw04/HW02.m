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


function radiobutton1_Callback(hObject, eventdata, handles)

set(handles.radiobutton1, 'Value', 1);
set(handles.radiobutton2, 'Value', 0);


function radiobutton2_Callback(hObject, eventdata, handles)

set(handles.radiobutton1, 'Value', 0);
set(handles.radiobutton2, 'Value', 1);


function radiobutton3_Callback(hObject, eventdata, handles)

set(handles.radiobutton3, 'Value', 1);
set(handles.radiobutton4, 'Value', 0);
set(handles.radiobutton5, 'Value', 0);


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)

set(handles.radiobutton3, 'Value', 0);
set(handles.radiobutton4, 'Value', 1);
set(handles.radiobutton5, 'Value', 0);


function radiobutton5_Callback(hObject, eventdata, handles)

set(handles.radiobutton3, 'Value', 0);
set(handles.radiobutton4, 'Value', 0);
set(handles.radiobutton5, 'Value', 1);


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


function filter_H(hObject, eventdata, handles)

% cut-off frequency (D0), order (n)
D0 = str2double( get(handles.edit2, 'String') );
n = str2double( get(handles.edit3, 'String') );

[M, N] = size(handles.I);
P = 2*M;
Q = 2*N;

% filter
handles.H = zeros(P, Q);
D = zeros(P, Q);

% Lowpass
% ideal
if handles.radiobutton1.Value == 1 && handles.radiobutton3.Value == 1
    for i = 1:P
        for j = 1:Q
            D(i, j) = ( (i - P/2)^2 + ( j - Q/2 )^2 )^(1/2);
            if D(i, j) <= D0
                handles.H(i, j) = 1;
            end
        end
    end
    
% butterworth
elseif handles.radiobutton1.Value == 1 && handles.radiobutton4.Value == 1
    for i = 1:P
        for j = 1:Q
            D(i, j) = ( (i - P/2)^2 + ( j - Q/2 )^2 )^(1/2);
            handles.H(i, j) = 1 / ( 1 + ( D(i, j)/D0 )^(2*n) );
        end
    end
    
% gaussian    
elseif handles.radiobutton1.Value == 1 && handles.radiobutton5.Value == 1
    for i = 1:P
        for j = 1:Q
            D(i, j) = ( (i - P/2)^2 + ( j - Q/2 )^2 )^(1/2);
            handles.H(i, j) = exp( -( D(i, j) )^2 / ( 2*D0^2 ) );
        end
    end
    
% ideal    
elseif handles.radiobutton2.Value == 1 && handles.radiobutton3.Value == 1
    for i = 1:P
        for j = 1:Q
            D(i, j) = ( (i - P/2)^2 + ( j - Q/2 )^2 )^(1/2);
            if D(i, j) > D0
                handles.H(i, j) = 1;
            end
        end
    end
    
% butterworth   
elseif handles.radiobutton2.Value == 1 && handles.radiobutton4.Value == 1
    for i = 1:P
        for j = 1:Q
            D(i, j) = ( (i - P/2)^2 + ( j - Q/2 )^2 )^(1/2);
            handles.H(i, j) = 1 / ( 1 + ( D0/D(i, j) )^(2*n) );
        end
    end

% gaussian
elseif handles.radiobutton2.Value == 1 && handles.radiobutton5.Value == 1
    for i = 1:P
        for j = 1:Q
            D(i, j) = ( (i - P/2)^2 + ( j - Q/2 )^2 )^(1/2);
            handles.H(i, j) = 1 - exp( -( D(i, j) )^2 / ( 2*D0^2 ) );
        end
    end
    
    
end

handles.output = hObject;
guidata(hObject, handles);


function pushbutton2_Callback(hObject, eventdata, handles)

% image processing
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
filter_H(hObject, eventdata, handles);
handles = guidata(hObject);
G = handles.H .* F;

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
