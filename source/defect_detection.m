function varargout = defect_detection(varargin)
% DEFECT_DETECTION MATLAB code for defect_detection.fig
%      DEFECT_DETECTION, by itself, creates a new DEFECT_DETECTION or raises the existing
%      singleton*.
%
%      H = DEFECT_DETECTION returns the handle to a new DEFECT_DETECTION or the handle to
%      the existing singleton*.
%
%      DEFECT_DETECTION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DEFECT_DETECTION.M with the given input arguments.
%
%      DEFECT_DETECTION('Property','Value',...) creates a new DEFECT_DETECTION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before defect_detection_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to defect_detection_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help defect_detection

% Last Modified by GUIDE v2.5 30-Jun-2018 10:52:06

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @defect_detection_OpeningFcn, ...
                   'gui_OutputFcn',  @defect_detection_OutputFcn, ...
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


% --- Executes just before defect_detection is made visible.
function defect_detection_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to defect_detection (see VARARGIN)

% Choose default command line output for defect_detection
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes defect_detection wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = defect_detection_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

handles.HasImage = 0;
guidata(hObject, handles);
end

% --- Executes on selection change in ImageNameShow_listbox.
end

% --- Executes during object creation, after setting all properties.
function SelectFolder_BUT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SelectFolder_BUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
end

function ImageNameShow_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to ImageNameShow_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ImageNameShow_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ImageNameShow_listbox
string = get(hObject,'string');
if strcmp(char(string),hObject.UserData) > 0
    return   
end
handles.HasImage = 1;
image_index = get(hObject,'value');

handles.image = imread( fullfile(handles.floder_name,handles.image_filename{image_index}));
axes(handles.axes_orginal_image);
imshow(handles.image);
guidata(hObject, handles);
end

% --- Executes during object creation, after setting all properties.
function ImageNameShow_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ImageNameShow_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
hObject.UserData = hObject.String;
end

% --- Executes on button press in SelectFolder_BUT.
function SelectFolder_BUT_Callback(hObject, eventdata, handles)
% hObject    handle to SelectFolder_BUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% [filename,pathname]=uigetfile({'*.jpg';'*.bmp';'*.gif'},'选择图片');

handles.floder_name = uigetdir();
if handles.floder_name == 0
    errordlg('请重新选择路径');
    return
end
file_list = dir(handles.floder_name);
file_list( [file_list.isdir] == 1 ) = []; % 去掉文件夹
file_volume = length(file_list);

% handles.image_wholefilename = cell(file_volume,1);
handles.image_filename = cell(file_volume,1);
n = uint8(0);
for i = 1:file_volume
    filefullname = fullfile(handles.floder_name,file_list(i).name);
    [~,name,ext] = fileparts(filefullname);
       
    if strcmp(ext,{'.jpg', '.bmp','.png'}) == 0 %去掉非图像文件
        n = n + 1;
        continue;
    end
%     handles.image_wholefilename{i-n} = filefullname;
    handles.image_filename{i-n} = strcat(name,ext);
end

if n > 0
    handles.image_filename((file_volume - n + 1):file_volume) = [];
end

char_image_filename = char(handles.image_filename);

set(handles.ImageNameShow_listbox,'string',{char_image_filename});
set(handles.ImageNameShow_listbox,'value',1);
set(handles.label1,'visible','on');
guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function axes_orginal_image_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes_orginal_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

axis off;
% Hint: place code in OpeningFcn to populate axes_orginal_image
end

% --- Executes on button press in ExecuteProce_BUT.
function ExecuteProce_BUT_Callback(hObject, eventdata, handles)
% hObject    handle to ExecuteProce_BUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.HasImage == 0
    return
end

figure;
set(gcf,'position',[100 100 1400 600]);
image = adjustImage(handles.image);
suptitle('中值滤波→水平检测→垂直检测→结果相加');

subplot(141);
image = bulrImage(image);
% title('经过三次中值滤波');
imshow(image);

subplot(142);
[imageH,horIndex] = horizontal_detection(image);
% title('horizontal detection');
imshow(imageH);

subplot(143);
[imageV,verIndex] = vertical_detection(image);
% title('vertical detection');
imshow(imageV);

subplot(144);
image = mergeImage(image,horIndex,verIndex);
% title('merge');
imshow(image);
end

% --- Executes during object creation, after setting all properties.
function ExecuteProce_BUT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ExecuteProce_BUT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [image_after] = adjustImage(image)

image_after = imresize(image,[512 512]);
if ndims(image_after) == 3 % 说明是24位图
   image_after = rgb2gray(image_after);
% elseif ndims(image_after) == 1 % 说明是8位图 就不用灰度化
%         
% end
end
w=fspecial('average',[3 3]);
image_after = imfilter(image_after,w);
end

function [image_after] = bulrImage(image)
for x = 1:4
    image_after = (medfilt2(image,[5 5]));
end
end

function [image_after,horizontalIndex] = horizontal_detection(image)
    horizontalIndex = searchFeng(image);
    image(horizontalIndex) = 255;
    image_after = image;   
end

function [image_after,verticalIndex] = vertical_detection(image)
    image = imrotate(image,90);
    verticalIndex = searchFeng(image);
    image(verticalIndex) = 255;   
    image_after = imrotate(image,-90);
end

function [image_after] = mergeImage(image,horIndex,verIndex)
    [Image_Row,Image_Col] = size(image);
    Zero_array = zeros(Image_Row,Image_Col);
    Zero_array(verIndex) = 1;
    Zero_array = imrotate(Zero_array,-90);
    vertical_linearindex_after = find(Zero_array == 1);

    common_index = intersect(horIndex,vertical_linearindex_after);
    
    image(common_index) = 255;
    image_after = image;
end
