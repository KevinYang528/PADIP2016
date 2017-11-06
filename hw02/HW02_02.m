function varargout = HW02_02(varargin)
% HW02_02 MATLAB code for HW02_02.fig
%      HW02_02, by itself, creates a new HW02_02 or raises the existing
%      singleton*.
%
%      H = HW02_02 returns the handle to a new HW02_02 or the handle to
%      the existing singleton*.
%
%      HW02_02('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in HW02_02.M with the given input arguments.
%
%      HW02_02('Property','Value',...) creates a new HW02_02 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before HW02_02_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to HW02_02_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help HW02_02

% Last Modified by GUIDE v2.5 19-Oct-2016 17:22:21

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @HW02_02_OpeningFcn, ...
                   'gui_OutputFcn',  @HW02_02_OutputFcn, ...
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


% --- Executes just before HW02_02 is made visible.
function HW02_02_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to HW02_02 (see VARARGIN)
handles.threshold_A = 128;
handles.threshold_B = 128;
handles.bri_A = 0;
handles.bri_B = 0;
handles.con_A = 1;
handles.con_B = 1;
handles.resize_A = 0; 
handles.resize_B = 0;
handles.grl_A = 0;
handles.grl_B = 0;
handles.his_A = 0;
handles.his_B = 0;
% Choose default command line output for HW02_02
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes HW02_02 wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = HW02_02_OutputFcn(hObject, eventdata, handles) 
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

filename = uigetfile({'*.jpg;*.tif;*.png;*.gif;*.bmp','All Image Files'});	
handles.I = imread(filename);

axes(handles.axes1);
imshow(handles.I);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% RGB
handles.R = uint16(handles.I(:, :, 1));
handles.G = uint16(handles.I(:, :, 2));
handles.B = uint16(handles.I(:, :, 3));

% Grayscale
handles.Gray_A = (handles.R + handles.G + handles.B)/3.0;
handles.Gray_A = uint8( handles.Gray_A*handles.con_A + handles.bri_A );

% Spatial resolution
if handles.resize_A > 0
    for m = 1:round(handles.resize_A)
        [rows, columns, ~] = size(handles.Gray_A);      
        c = zeros(round(rows/2),round(columns/2));
        c = uint8(c);
        handles.Gray_A= double(handles.Gray_A);
        i=1;
        for x=1:2:rows-1;
            j = 1; 
            for y=1:2:columns-1;
                c(i, j) = ( handles.Gray_A(x,y) + handles.Gray_A(x,y+1) + handles.Gray_A(x+1,y) + handles.Gray_A(x+1,y+1) ) / 4;
                j = j+1;
            end
            i = i+1;
        end
        handles.Gray_A = c;
    end  
end
handles.Gray_A = uint8(handles.Gray_A);

% adjust gray level
handles.Gray_A = round( handles.Gray_A / (2^handles.grl_A) ) * 2^handles.grl_A;

% histogram equalization
if handles.his_A == 1
    [row, col] = size(handles.Gray_A);
    
    % cdf
    cdf = handles.H_A;
    for m = 1:256
        cdf(m) = sum(handles.H_A(1:m));
    end
        
    for i = 1:row
        for j = 1:col
            handles.Gray_A= double(handles.Gray_A);
             handles.Gray_A(i, j) = round( ( cdf( handles.Gray_A(i, j)+1 ) - min(cdf) )...
                 * ( (256 / (2^handles.grl_A) ) - 1) / ((row*col) - min(cdf)) );
        end
    end
    handles.his_A = 0;
    
end
handles.Gray_A = uint8(handles.Gray_A);

% histogram
[row, col, ~] = size(handles.Gray_A);

handles.H_A = zeros(1, 256);
for i = 1:row
    for j = 1:col
        handles.H_A( handles.Gray_A(i, j)+1 ) = handles.H_A( handles.Gray_A(i, j)+1 ) + 1;
    end
end

axes(handles.axes2);
imshow(handles.Gray_A);

x = 0:255;
axes(handles.axes3); 
bar(x, handles.H_A, 'FaceColor', [0 0 0], 'BarWidth', 1);


handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% RGB
handles.R = handles.I(:, :, 1);
handles.G = handles.I(:, :, 2);
handles.B = handles.I(:, :, 3);

% Grayscale
handles.Gray_B = ( 0.299*handles.R + 0.587*handles.G + 0.114*handles.B)*handles.con_B + handles.bri_B;

% Spatial resolution
if handles.resize_B > 0
    for m = 1:round(handles.resize_B)
        [rows, columns, ~] = size(handles.Gray_B);      
        c = zeros(round(rows/2),round(columns/2));
        c = uint8(c);
        handles.Gray_B= double(handles.Gray_B);
        i=1;
        for x=1:2:rows-1;
            j = 1; 
            for y=1:2:columns-1;
                c(i, j) = ( handles.Gray_B(x,y) + handles.Gray_B(x,y+1) + handles.Gray_B(x+1,y) + handles.Gray_B(x+1,y+1) ) / 4;
                j = j+1;
            end
            i = i+1;
        end
        handles.Gray_B = c;
    end  
end
handles.Gray_B = uint8(handles.Gray_B);

% adjust gray level
handles.Gray_B = round( handles.Gray_B / (2^handles.grl_B) ) * 2^handles.grl_B;

% histogram equalization
if handles.his_B == 1
    [row, col] = size(handles.Gray_B);
    
    % cdf
    cdf = handles.H_B;
    for m = 1:256
        cdf(m) = sum(handles.H_B(1:m));
    end
        
    for i = 1:row
        for j = 1:col
            handles.Gray_B= double(handles.Gray_B);
            handles.Gray_B(i, j) = round( ( cdf( handles.Gray_B(i, j)+1 ) - min(cdf) )...
                * ( (256 / (2^handles.grl_B) ) - 1) / ((row*col) - min(cdf)) );
        end
    end
    handles.his_B = 0; 
end
handles.Gray_B = uint8(handles.Gray_B);

% histogram
[row, col, ~] = size(handles.Gray_B);

handles.H_B = zeros(1, 256);
for i = 1:row
    for j = 1:col
        handles.H_B( handles.Gray_B(i, j)+1 ) =  handles.H_B( handles.Gray_B(i, j)+1 ) + 1;
    end
end

axes(handles.axes5);
imshow(handles.Gray_B);
x = 0:255;
axes(handles.axes6); 
bar(x, handles.H_B, 'FaceColor', [0 0 0], 'BarWidth', 1);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton5.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



handles.output = hObject;
guidata(hObject, handles);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double

handles.threshold_A = str2double(get(hObject,'String'));

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


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.binary_A = handles.Gray_A;
row = size(handles.I, 1);
col = size(handles.I, 2);

for i = 1:row
    for j = 1:col
       if handles.Gray_A(i, j) <= handles.threshold_A
           handles.binary_A(i, j) = 0;
      else
          handles.binary_A(i, j) = 255;
      end
    end
end

axes(handles.axes4);
imshow(handles.binary_A);

handles.output = hObject;
guidata(hObject, handles);



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


handles.threshold_B = str2double(get(hObject,'String'));

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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.binary_B = handles.Gray_B;
row = size(handles.I, 1);
col = size(handles.I, 2);

for i = 1:row
    for j = 1:col
       if handles.Gray_B(i, j) <= handles.threshold_B
           handles.binary_B(i, j) = 0;
       else
           handles.binary_B(i, j) = 255;
       end
    end
end

axes(handles.axes7);
imshow(handles.binary_B);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.bri_A = get(handles.slider1, 'Value');
pushbutton2_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider2_Callback(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
handles.bri_B = get(handles.slider2, 'Value');
pushbutton3_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider3_Callback(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.con_A = get(handles.slider3, 'Value');
pushbutton2_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider4_Callback(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.con_B = get(handles.slider4, 'Value');
pushbutton3_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider5_Callback(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.resize_A = get(handles.slider5, 'Value');
pushbutton2_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider6_Callback(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.resize_B = get(handles.slider6, 'Value');
pushbutton3_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider7_Callback(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.grl_A = get(handles.slider7, 'Value');
pushbutton2_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function slider7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function slider8_Callback(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

handles.grl_B = get(handles.slider8, 'Value');
pushbutton3_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function slider8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.his_A = 1;
pushbutton2_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);

% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.his_B = 1;
pushbutton3_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% initialization
handles.threshold_A = 128;
handles.bri_A = 0;
handles.con_A = 1;
handles.resize_A = 0; 
handles.grl_A = 0;
handles.his_A = 0;

set(handles.slider1, 'value', 0);
set(handles.slider3, 'value', 1);
set(handles.slider5, 'value', 0);
set(handles.slider7, 'value', 0);
set(handles.edit1, 'string', '128');

pushbutton2_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);


% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% initialization

handles.threshold_B = 128;
handles.bri_B = 0;
handles.con_B = 1;
handles.con_B = 1;
handles.resize_B = 0;
handles.grl_B = 0;
handles.his_B = 0;

set(handles.slider2, 'value', 0);
set(handles.slider4, 'value', 1);
set(handles.slider6, 'value', 0);
set(handles.slider8, 'value', 0);
set(handles.edit2, 'string', '128');

pushbutton3_Callback(hObject, eventdata, handles);

handles.output = hObject;
guidata(hObject, handles);
