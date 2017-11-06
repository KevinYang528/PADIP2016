function varargout = hw01_02(varargin)
% HW01_02 MATLAB code for hw01_02.fig
%      HW01_02, by itself, creates a new HW01_02 or raises the existing
%      singleton*.
%
%      H = HW01_02 returns the handle to a new HW01_02 or the handle to
%      the existing singleton*.
%
%      HW01_02('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HW01_02.M with the given input arguments.
%
%      HW01_02('Property','Value',...) creates a new HW01_02 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before hw01_02_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to hw01_02_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help hw01_02

% Last Modified by GUIDE v2.5 07-Oct-2016 12:01:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @hw01_02_OpeningFcn, ...
                   'gui_OutputFcn',  @hw01_02_OutputFcn, ...
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


% --- Executes just before hw01_02 is made visible.
function hw01_02_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to hw01_02 (see VARARGIN)

handles.Add = 5;
handles.Multi = 1.5;

% Choose default command line output for hw01_02
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes hw01_02 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = hw01_02_OutputFcn(hObject, eventdata, handles) 
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
handles.I = uint8(F);
for i = 1:64
     for j = 1:64
        % 0~9
        if handles.I(i, j) >= 48 &&  handles.I(i, j) <= 57
            handles.I(i, j) = handles.I(i, j) - 48;
        % 10~31
        elseif handles.I(i, j) >= 65 &&  handles.I(i, j) <= 86
            handles.I(i, j) = handles.I(i, j) - 55;     
        end
        if handles.I(i, j) > 31
            handles.I(i, j) = 31;
        end
    end
end
fclose(fid);

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
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
handles.J = uint8(F);
for i = 1:64
     for j = 1:64
        % 0~9
        if handles.J(i, j) >= 48 &&  handles.J(i, j) <= 57
            handles.J(i, j) = handles.J(i, j) - 48;
        % 10~31
        elseif handles.J(i, j) >= 65 &&  handles.J(i, j) <= 86
            handles.J(i, j) = handles.J(i, j) - 55;     
        end
        if handles.J(i, j) > 31
            handles.J(i, j) = 31;
        end
    end
end
fclose(fid);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% histogram
H = zeros(1, 32);
for i = 1:64
    for j = 1:64
        H( handles.I(i, j)+1 ) =   H( handles.I(i, j)+1 ) + 1;
    end
end

% imshow,  histogram plot
axes(handles.axes1); imshow(handles.I*8);            
x = 0:31;
axes(handles.axes6); bar(x, H, 'FaceColor', [0 0 0], 'BarWidth', 1);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Add or subtract a constant value to each pixel in the image
I1 = handles.I;
for i = 1:64
   for j = 1:64
        I1(i, j) = handles.I(i, j) + handles.Add;
   end
end

% histogram
H1 = zeros(1, 32);
for i = 1:64
    for j = 1:64
        % 若加上像素後大於31，使其等於31
        if I1(i, j) > 31
            I1(i, j) = 31;
        end
        H1( I1(i, j)+1 ) =   H1( I1(i, j)+1 ) + 1;
    end
end

axes(handles.axes2); imshow(I1*8);
x = 0:31;
axes(handles.axes7); bar(x, H1, 'FaceColor', [0 0 0], 'BarWidth', 1);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Multiply a constant to each pixel in the image.

I2 = handles.I;
for i = 1:64
   for j = 1:64
        I2(i, j) = round( handles.I(i, j)*handles.Multi );
   end
end

% histogram
H2 = zeros(1, 32);
for i = 1:64
    for j = 1:64
        % 若加上像素後大於31，使其等於31
        if I2(i, j) > 31
            I2(i, j) = 31;
        end
        H2( I2(i, j)+1 ) =   H2( I2(i, j)+1 ) + 1;
    end
end

axes(handles.axes3); imshow(I2*8);
x = 0:31;
axes(handles.axes8); bar(x, H2, 'FaceColor', [0 0 0], 'BarWidth', 1);

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I3 = uint8( zeros(64) );
for i = 1:64
   for j = 1:64
        I3(i, j) = handles.J(i, j)*0.5 + handles.I(i, j)*0.5;
   end
end

% histogram
H3 = zeros(1, 32);
for i = 1:64
    for j = 1:64
        % 若加上像素後大於31，使其等於31
        if I3(i, j) > 31
            I3(i, j) = 31;
        end
        H3( I3(i, j)+1 ) =   H3( I3(i, j)+1 ) + 1;
    end
end

axes(handles.axes4); imshow(I3*8);
x = 0:31;
axes(handles.axes9); bar(x, H3, 'FaceColor', [0 0 0], 'BarWidth', 1);

handles.output = hObject;
guidata(hObject, handles);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

paddle = uint8( zeros( 66 ) );
for i = 1:64
    for j = 1:64
        paddle(i+1, j+1) = handles.I(i, j);
    end
end
paddle2 = uint8( ones( 66 ) );
for i = 2:65
    for j = 2:65
        paddle2(i, j) = paddle(i, j) - paddle(i, j-1);
    end
end
I4 = uint8( ones( 64 ) );
for i = 1:64
    for j = 1:64
        I4(i, j) = paddle2(i+1, j+1);
    end
end

% histogram
H4 = zeros(1, 32);
for i = 1:64
    for j = 1:64
        % 若加上像素後大於31，使其等於31
        if I4(i, j) > 31
            I4(i, j) = 31;
        elseif I4(i, j) < 0
            I4(i, j) = 0;
        end
        H4( I4(i, j)+1 ) =   H4( I4(i, j)+1 ) + 1;
    end
end

axes(handles.axes5); imshow(I4*8);
x = 0:31;
axes(handles.axes10); bar(x, H4, 'FaceColor', [0 0 0], 'BarWidth', 1);

handles.output = hObject;
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

% 更改加減的數字

handles.Add = str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double

% 更改乘以的數字
handles.Multi = str2double(get(hObject,'String'));

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
