function varargout = ImgProcessing(varargin)
% IMGPROCESSING MATLAB code for ImgProcessing.fig
%      IMGPROCESSING, by itself, creates a new IMGPROCESSING or raises the existing
%      singleton*.
%
%      H = IMGPROCESSING returns the handle to a new IMGPROCESSING or the handle to
%      the existing singleton*.
%
%      IMGPROCESSING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in IMGPROCESSING.M with the given input arguments.
%
%      IMGPROCESSING('Property','Value',...) creates a new IMGPROCESSING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ImgProcessing_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ImgProcessing_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ImgProcessing

% Last Modified by GUIDE v2.5 15-Dec-2024 00:05:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ImgProcessing_OpeningFcn, ...
                   'gui_OutputFcn',  @ImgProcessing_OutputFcn, ...
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


% --- Executes just before ImgProcessing is made visible.
function ImgProcessing_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ImgProcessing (see VARARGIN)

% Choose default command line output for ImgProcessing
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ImgProcessing wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ImgProcessing_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%------------------ Select image-----------------------
% --- Executes on button press in pushbutton1.

function pushbutton1_Callback(hObject, eventdata, handles)
global i
[filename,path]=uigetfile({'*.jpg;.png','Image Files'},'Select an image')
if filename == 0
    disp('User cancelled')
else   
    i = imread(fullfile(path,filename));
    axes(handles.axes1)
    imshow(i)
end    

%------------------------convert to grey---------------------
function pushbutton5_Callback(hObject, eventdata, handles)
global i
global j
% j = rgb2gray(i)
j = i(:,:,1)*0.2989+i(:,:,2)*0.5870+i(:,:,3)*0.1140;
axes(handles.axes2)
imshow(j)

%--------------------add noise-------------------
% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
global j; 
global jnoised ;
jnoised = imnoise(j,'salt & pepper',0.05);
axes(handles.axes2);
imshow(jnoised);
% --------------------median filter--------------------------
function pushbutton3_Callback(hObject, eventdata, handles)
global jnoised;
jmid_filtered = medfilt2(jnoised);
axes(handles.axes2);
imshow(jmid_filtered);
% -------------------average filter--------------------------
function pushbutton4_Callback(hObject, eventdata, handles)
global jnoised ;
mask = fspecial('average',[3 3]);
javg_filtered = filter2(mask,jnoised);
axes(handles.axes2);
imshow(uint8(javg_filtered));

%------------------Detect Edges-----------------------
function popupmenu4_Callback(hObject, eventdata, handles)
global j;
if handles.popupmenu4.Value==1
    a=edge(j,'sobel');
elseif handles.popupmenu4.Value==2
        a=edge(j,'prewitt');
elseif handles.popupmenu4.Value==3
        a=edge(j,'roberts');  
elseif handles.popupmenu4.Value==4
        a=edge(j,'canny');    
elseif handles.popupmenu4.Value==5
        a=edge(j,'log'); 
elseif handles.popupmenu4.Value==6
        a=edge(j,'log',0.02,1);
end
axes(handles.axes7)
imshow(a);

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
  
%------------------------------histogram equalization-------------------

function pushbutton7_Callback(hObject, eventdata, handles)
global j;
k = j;
% RGB Equlization
% k(:,:,1) = histeq(i(:,:,1));
% k(:,:,2) = histeq(i(:,:,2));
% k(:,:,3) = histeq(i(:,:,3));
equalizedimg = histeq(j);
axes(handles.axes4)
imshow(k);


%---------------------------Plotting Histogram--------------------------
% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global i
red_histo = imhist(i(:,:,1));
figure
plot(red_histo, 'red');
green_histo = imhist(i(:,:,2));
figure
plot(green_histo, 'green');
blue_histo = imhist(i(:,:,3));
figure
plot(blue_histo, 'blue');


%-------------------------histogram before-------------------
% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global j
figure
% axes(handles.axes12);
imhist(j);


%----------------------contrast stretching------------------
% --- Executes on button press in pushbutton8.
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function pushbutton8_Callback(hObject, eventdata, handles)
global j
global jimadjust
lowIn = str2double(get(handles.edit1, 'String'))/255;
highIn = str2double(get(handles.edit2, 'String'))/255;
jimadjust = imadjust(j, [lowIn highIn], []);
axes(handles.axes12);
imshow(jimadjust);


%--------------------------Histogram After----------------------
% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global jimadjust
figure
% axes(handles.axes12);
imhist(jimadjust);

function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


%---------------------Image Negative--------------------
% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global j
neg = double(j);
negScale = 1 / max(neg(:));
neg = 1 - neg * negScale;
axes(handles.axes13);
imshow(neg);
