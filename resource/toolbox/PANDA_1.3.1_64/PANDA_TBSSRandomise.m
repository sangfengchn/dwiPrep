function varargout = PANDA_TBSSRandomise(varargin)
% GUI for TBSS randomise statistics (an independent component of software PANDA), by Zaixu Cui 
%-------------------------------------------------------------------------- 
%      Copyright(c) 2015
%      State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University
%      Written by <a href="zaixucui@gmail.com">Zaixu Cui</a>
%      Mail to Author:  <a href="zaixucui@gmail.com">zaixucui@gmail.com</a>
%      Version 1.3.0;
%      Date 
%      Last edited 
%--------------------------------------------------------------------------
% PANDA_TBSSRANDOMISE MATLAB code for PANDA_TBSSRandomise.fig
%      PANDA_TBSSRANDOMISE, by itself, creates a new PANDA_TBSSRANDOMISE or raises the existing
%      singleton*.
%
%      H = PANDA_TBSSRANDOMISE returns the handle to a new PANDA_TBSSRANDOMISE or the handle to
%      the existing singleton*.
%
%      PANDA_TBSSRANDOMISE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PANDA_TBSSRANDOMISE.M with the given input arguments.
%
%      PANDA_TBSSRANDOMISE('Property','Value',...) creates a new PANDA_TBSSRANDOMISE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PANDA_TBSSRandomise_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PANDA_TBSSRandomise_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PANDA_TBSSRandomise

% Last Modified by GUIDE v2.5 06-May-2016 17:56:54

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PANDA_TBSSRandomise_OpeningFcn, ...
                   'gui_OutputFcn',  @PANDA_TBSSRandomise_OutputFcn, ...
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


% --- Executes just before PANDA_TBSSRandomise is made visible.
function PANDA_TBSSRandomise_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PANDA_TBSSRandomise (see VARARGIN)

% Choose default command line output for PANDA_TBSSRandomise
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes PANDA_TBSSRandomise wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global TBSSRandomise_Times;
global TBSSRandomise_Prefix;
global F_Contrast_check;
global Group_check;
global TBSSRandomise_Skeleton;
global TBSSRandomise_SkeletonMask;
global TBSSRandomise_DesignMatrix;
global TBSSRandomise_TContrast;
global TBSSRandomise_FContrast;
global TBSSRandomise_ResultPath;
TBSSRandomise_Skeleton = '';
set(handles.Skeleton_Edit, 'String', TBSSRandomise_Skeleton);
TBSSRandomise_SkeletonMask = '';
set(handles.SkeletonMask_Edit, 'String', TBSSRandomise_SkeletonMask);
TBSSRandomise_DesignMatrix = '';
set(handles.DesignMatrix_Edit, 'String', TBSSRandomise_DesignMatrix);
TBSSRandomise_TContrast = '';
set(handles.TContrast_Edit, 'String', TBSSRandomise_TContrast);
F_Contrast_check = 0;
set(handles.F_Contrast_check, 'Value', 0.0);
TBSSRandomise_FContrast = '';
set(handles.FContrast_Edit, 'Enable', 'off' );
set(handles.FContrast_Button, 'Enable', 'off');
Group_check = 0;
set(handles.Group_check, 'Value', 0.0);
TBSSRandomise_Group = '';
set(handles.Group_Edit, 'Enable', 'off' );
set(handles.Group_Button, 'Enable', 'off');
TBSSRandomise_Times = 5000;
set(handles.PermutationTimes_Edit, 'String', '5000');
TBSSRandomise_Prefix = 'tbss';
set(handles.Prefix_Edit, 'String', 'tbss');
TBSSRandomise_ResultPath = '';
set(handles.ResultPath_Edit, 'String', TBSSRandomise_ResultPath);
% Set icon
SetIcon(handles);


% --- Outputs from this function are returned to the command line.
function varargout = PANDA_TBSSRandomise_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Skeleton_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Skeleton_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Skeleton_Edit as text
%        str2double(get(hObject,'String')) returns contents of Skeleton_Edit as a double
global TBSSRandomise_Skeleton;
set(handles.Skeleton_Edit, 'String', TBSSRandomise_Skeleton);


% --- Executes during object creation, after setting all properties.
function Skeleton_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Skeleton_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
%end


% --- Executes on button press in Skeleton_Button.
function Skeleton_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Skeleton_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_Skeleton;
[Skeleton_FileName, Skeleton_ParentFolder] = uigetfile({'*.nii; *.nii.gz','4D skeleton (*.nii, *nii.gz)'},'Input 4D skeleton');
if ~isnumeric(Skeleton_FileName)
    TBSSRandomise_Skeleton = [Skeleton_ParentFolder Skeleton_FileName];
    set(handles.Skeleton_Edit, 'String', TBSSRandomise_Skeleton);
end


function SkeletonMask_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to SkeletonMask_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SkeletonMask_Edit as text
%        str2double(get(hObject,'String')) returns contents of SkeletonMask_Edit as a double
global TBSSRandomise_SkeletonMask;
set(handles.SkeletonMask_Edit, 'String', TBSSRandomise_SkeletonMask);


% --- Executes during object creation, after setting all properties.
function SkeletonMask_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SkeletonMask_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
%end


% --- Executes on button press in SkeletonMask_Button.
function SkeletonMask_Button_Callback(hObject, eventdata, handles)
% hObject    handle to SkeletonMask_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_SkeletonMask;
[SkeletonMask_FileName, SkeletonMask_ParentFolder] = uigetfile({'*.nii; *.nii.gz','skeleton mask (*.nii, *nii.gz)'},'Input skeleton mask');
if ~isnumeric(SkeletonMask_FileName)
    TBSSRandomise_SkeletonMask = [SkeletonMask_ParentFolder SkeletonMask_FileName];
    set(handles.SkeletonMask_Edit, 'String', TBSSRandomise_SkeletonMask);
end


function DesignMatrix_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to DesignMatrix_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of DesignMatrix_Edit as text
%        str2double(get(hObject,'String')) returns contents of DesignMatrix_Edit as a double
global TBSSRandomise_DesignMatrix;
set(handles.DesignMatrix_Edit, 'String', TBSSRandomise_DesignMatrix);


% --- Executes during object creation, after setting all properties.
function DesignMatrix_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DesignMatrix_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
%end


% --- Executes on button press in DesignMatrix_Button.
function DesignMatrix_Button_Callback(hObject, eventdata, handles)
% hObject    handle to DesignMatrix_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_DesignMatrix;
[DesignMatrix_FileName, DesignMatrix_ParentFolder] = uigetfile({'*.mat','design matrix (*.mat)'},'Input design matrix');
if ~isnumeric(DesignMatrix_FileName)
    TBSSRandomise_DesignMatrix = [DesignMatrix_ParentFolder DesignMatrix_FileName];
    set(handles.DesignMatrix_Edit, 'String', TBSSRandomise_DesignMatrix);
end


function PermutationTimes_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to PermutationTimes_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of PermutationTimes_Edit as text
%        str2double(get(hObject,'String')) returns contents of PermutationTimes_Edit as a double
global TBSSRandomise_Times;
TBSSRandomise_Times_Edit = get(hObject, 'string');
TBSSRandomise_Times = str2num(TBSSRandomise_Times_Edit);
if isempty(TBSSRandomise_Times)
    TBSSRandomise_Times_Edit = '';
    set(hObject, 'string', '');
    msgbox('Please input number, (i.e., 1000)');
end


% --- Executes during object creation, after setting all properties.
function PermutationTimes_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PermutationTimes_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
%end



function Prefix_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Prefix_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Prefix_Edit as text
%        str2double(get(hObject,'String')) returns contents of Prefix_Edit as a double
global TBSSRandomise_Prefix;
TBSSRandomise_Prefix = get(hObject, 'string');


% --- Executes during object creation, after setting all properties.
function Prefix_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Prefix_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
%if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
%end


% --- Executes on button press in TBSS_Statistic_Run.
function TBSS_Statistic_Run_Callback(hObject, eventdata, handles)
% hObject    handle to TBSS_Statistic_Run (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_Skeleton;
global TBSSRandomise_SkeletonMask;
global TBSSRandomise_DesignMatrix;
global TBSSRandomise_TContrast;
global TBSSRandomise_FContrast;
global TBSSRandomise_Group;
global TBSSRandomise_Times;
global TBSSRandomise_Prefix;
global TBSSRandomise_ResultPath;
global F_Contrast_check;
global Group_check;
global JobStatusMonitorTimerTBSSRandomise;
global FileLocationPointer;

FileLocationPointer = 0;

if isempty(TBSSRandomise_Skeleton)
    msgbox('Please input the 4D skeleton image!');
elseif ~exist(TBSSRandomise_Skeleton, 'file')
    msgbox('The 4D skeleton image does not exist, please check!');
elseif isempty(TBSSRandomise_SkeletonMask)
    msgbox('Please input the mask of skeleton!');
elseif ~exist(TBSSRandomise_SkeletonMask)
    msgbox('The skeleton mask does not exist, please check!');
elseif isempty(TBSSRandomise_DesignMatrix)
    msgbox('Please input the design matrix!');
elseif ~exist(TBSSRandomise_DesignMatrix, 'file')
    msgbox('The design matrix does not exist, please check!');
elseif isempty(TBSSRandomise_TContrast)
    msgbox('Please input the T contrast file!');
elseif ~exist(TBSSRandomise_TContrast)
    msgbox('The T contrast file does not exist, please check!');
elseif isempty(TBSSRandomise_Times)
    msgbox('Please input the times for permutation!');
elseif isempty(TBSSRandomise_Prefix)
    msgbox('Please input the prefix of the resultant files!');
elseif isempty(TBSSRandomise_ResultPath)
    msgbox('Please input the resultant folder path!');
else
    % Check whether the subjects quantity is equal to the rows quantity in
    % the designbutton matrix
    system(['fslval ' TBSSRandomise_Skeleton ' dim4 > ' pwd filesep 'PANDA_TBSSRandomise_System.txt']);
    dim4 = load([pwd filesep 'PANDA_TBSSRandomise_System.txt']);
    delete([pwd filesep 'PANDA_TBSSRandomise_System.txt']);
    fid = fopen(TBSSRandomise_DesignMatrix, 'r');
    while ~feof(fid)
        PointsQuantity_str = fgetl(fid);
        if strcmp(PointsQuantity_str([1:10]), '/NumPoints')
            PointsQuantity = str2num(PointsQuantity_str(12:end));
            break;
        end
    end
    if dim4 ~= PointsQuantity
        msgstr{1} = 'number of rows in design matrix doesn''t match';
        msgstr{2} = 'number of "time points" in input data!';
        msgbox(msgstr);
        return;
    end
    
    if ~exist(TBSSRandomise_ResultPath, 'dir')
        mkdir(TBSSRandomise_ResultPath);
    end
    try 
        x = 1;
        save([TBSSRandomise_ResultPath filesep 'permission_tag.mat'], 'x');
    catch
        LogPathPermissionDenied = 1;
        msgbox('Please change destination path, permission denied !');
        return;
    end
    DateNow = datevec(datenum(now));
    DateNowString = [num2str(DateNow(1)) '_' num2str(DateNow(2), '%02d') '_' num2str(DateNow(3), '%02d') '_' num2str(DateNow(4), '%02d') '_' num2str(DateNow(5), '%02d')];
    ParameterSaveFilePath = [TBSSRandomise_ResultPath  filesep DateNowString '.PANDA_TBSSRandomise'];
    save(ParameterSaveFilePath, 'TBSSRandomise_Skeleton', 'TBSSRandomise_SkeletonMask', 'TBSSRandomise_DesignMatrix', ...
        'TBSSRandomise_TContrast', 'TBSSRandomise_FContrast', 'TBSSRandomise_Times', 'TBSSRandomise_Prefix', ...
        'TBSSRandomise_ResultPath', 'F_Contrast_check', 'Group_check', 'TBSSRandomise_Group');
    TBSSRandomiseShLocation = [TBSSRandomise_ResultPath filesep 'TBSSRandomise.sh'];
    
    cmd_PANDA = ['randomise -i ' TBSSRandomise_Skeleton ' -o ' TBSSRandomise_ResultPath filesep TBSSRandomise_Prefix ' -m ' ...
            TBSSRandomise_SkeletonMask ' -d ' TBSSRandomise_DesignMatrix ' -t ' TBSSRandomise_TContrast];
    if F_Contrast_check
        if isempty(TBSSRandomise_FContrast)
            msgbox('Please input the F contrast file (.fts)!');
            return;
        elseif ~exist(TBSSRandomise_FContrast, 'file')
            msgbox('The F contrast file does not exist, please check!');
            return;
        else
            cmd_PANDA = [cmd_PANDA ' -f ' TBSSRandomise_FContrast];
        end
    end
    if Group_check
        if isempty(TBSSRandomise_Group)
            msgbox('Please input the group file (.grp)');
            return;
        elseif ~exist(TBSSRandomise_Group, 'file')
            msgbox('The group file does not exist, please check!');
            return;
        else
            cmd_PANDA = [cmd_PANDA ' -e ' TBSSRandomise_Group];
        end
    end
    cmd_PANDA = [cmd_PANDA ' -n ' num2str(TBSSRandomise_Times) ' --T2 > ' TBSSRandomise_ResultPath filesep 'tbss.log &'];
    system(cmd_PANDA);
    
    fid = fopen(TBSSRandomiseShLocation, 'w');
    BashString = '#!/bin/bash';
    fprintf(fid, '%s\n%s', BashString, cmd_PANDA);
    fclose(fid);
    system(['which sh > ' pwd filesep 'PANDA_TBSSRandomise_System.txt']);
    fid = fopen([pwd filesep 'PANDA_TBSSRandomise_System.txt']);
    ShPath = fgets(fid);
    fclose(fid);
    delete([pwd filesep 'PANDA_TBSSRandomise_System.txt']);
    system([ShPath(1:end-1) ' ' TBSSRandomiseShLocation ' &']);
    
    set(handles.DesignButton, 'Enable', 'off');
    set(handles.Skeleton_Edit, 'Enable', 'off');
    set(handles.Skeleton_Button, 'Enable', 'off');
    set(handles.SkeletonMask_Edit, 'Enable', 'off');
    set(handles.SkeletonMask_Button, 'Enable', 'off');
    set(handles.DesignMatrix_Edit, 'Enable', 'off');
    set(handles.DesignMatrix_Button, 'Enable', 'off');
    set(handles.TContrast_Edit, 'Enable', 'off');
    set(handles.TContrast_Button, 'Enable', 'off');
    set(handles.F_Contrast_check, 'Enable', 'off');
    set(handles.FContrast_Edit, 'Enable', 'off');
    set(handles.FContrast_Button, 'Enable', 'off');
    set(handles.Group_check, 'Enable', 'off');
    set(handles.Group_Edit, 'Enable', 'off');
    set(handles.Group_Button, 'Enable', 'off');
    set(handles.PermutationTimes_Edit, 'Enable', 'off');
    set(handles.Prefix_Edit, 'Enable', 'off');
    set(handles.ResultPath_Edit, 'Enable', 'off');
    set(handles.ResultPath_Button, 'Enable', 'off');
    set(handles.TBSS_Statistic_Run, 'Enable', 'off');
    % Start monitor function
    JobStatusMonitorTimerTBSSRandomise = timer( 'TimerFcn', {@JobStatusMonitorTBSSRandomise, handles}, 'period', 5, 'ExecutionMode', 'fixedRate');
    start(JobStatusMonitorTimerTBSSRandomise);
    edit ([TBSSRandomise_ResultPath filesep 'tbss.log']);
    
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in Image1.
function Image1_Callback(hObject, eventdata, handles)
% hObject    handle to Image1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PANDA_Help;


% --- Executes on button press in Image2.
function Image2_Callback(hObject, eventdata, handles)
% hObject    handle to Image2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PANDA_Help;


% --- Executes on button press in DesignButton.
function DesignButton_Callback(hObject, eventdata, handles)
% hObject    handle to DesignButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PANDA_TBSSDesign;


function TContrast_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to TContrast_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of TContrast_Edit as text
%        str2double(get(hObject,'String')) returns contents of TContrast_Edit as a double
global TBSSRandomise_TContrast;
set(handles.TContrast_Edit, 'String', TBSSRandomise_TContrast);


% --- Executes during object creation, after setting all properties.
function TContrast_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to TContrast_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in TContrast_Button.
function TContrast_Button_Callback(hObject, eventdata, handles)
% hObject    handle to TContrast_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_TContrast;
[TContrast_FileName, TContrast_ParentFolder] = uigetfile({'*.con','contrast (*.con)'},'Input T contrast file');
if ~isnumeric(TContrast_FileName)
    TBSSRandomise_TContrast = [TContrast_ParentFolder TContrast_FileName];
    set(handles.TContrast_Edit, 'String', TBSSRandomise_TContrast);
end


function FContrast_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to FContrast_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of FContrast_Edit as text
%        str2double(get(hObject,'String')) returns contents of FContrast_Edit as a double
global TBSSRandomise_FContrast;
set(handles.FContrast_Edit, 'String', TBSSRandomise_FContrast);


% --- Executes during object creation, after setting all properties.
function FContrast_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FContrast_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in FContrast_Button.
function FContrast_Button_Callback(hObject, eventdata, handles)
% hObject    handle to FContrast_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_FContrast;
[FContrast_FileName, FContrast_ParentFolder] = uigetfile({'*.fts','contrast (*.fts)'},'Input f contrast file');
if ~isnumeric(FContrast_FileName)
    TBSSRandomise_FContrast = [FContrast_ParentFolder FContrast_FileName];
    set(handles.FContrast_Edit, 'String', TBSSRandomise_FContrast);
end


% --- Executes on button press in F_Contrast_check.
function F_Contrast_check_Callback(hObject, eventdata, handles)
% hObject    handle to F_Contrast_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of F_Contrast_check
global F_Contrast_check;
if get(hObject, 'value') == 1
    F_Contrast_check = 1;
    set(handles.FContrast_Edit, 'Enable', 'on');
    set(handles.FContrast_Button, 'Enable', 'on');
else
    F_Contrast_check = 0;
    set(handles.FContrast_Edit, 'Enable', 'off');
    set(handles.FContrast_Button, 'Enable', 'off');
end



function ResultPath_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to ResultPath_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ResultPath_Edit as text
%        str2double(get(hObject,'String')) returns contents of ResultPath_Edit as a double
global TBSSRandomise_ResultPath;
TBSSRandomise_ResultPath = get( hObject, 'string' );


% --- Executes during object creation, after setting all properties.
function ResultPath_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ResultPath_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in ResultPath_Button.
function ResultPath_Button_Callback(hObject, eventdata, handles)
% hObject    handle to ResultPath_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_ResultPath;
ResultPath = uigetdir;
if ~isnumeric(ResultPath)
    TBSSRandomise_ResultPath = ResultPath;
    set(handles.ResultPath_Edit, 'String', TBSSRandomise_ResultPath);
end


% --- Executes during object creation, after setting all properties.
function Skeleton_Button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Skeleton_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in Display_Button.
function Display_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Display_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PANDA_TBSSDisplay;


% Set Icon
function SetIcon(handles)
image_data(:,:,1)=[254  254  254  254  254  254  254  254  255  235  251  255  236  255  242  255  255  255  234  255  255  242  255  242  255  253  251  253  255  255  251  246  255  249  250  253  248  251  255  251  243  245  255  255  241
  254  254  254  254  254  254  254  254  241  255  255  238  255  249  236  247  245  241  255  246  239  255  255  255  253  253  253  253  253  254  255  255  251  253  255  255  255  255  251  251  255  248  244  250  253
  254  254  254  254  254  254  254  254  255  255  236  254  255  226  195  180  172  215  255  255  252  253  254  235  248  254  255  255  254  250  249  251  250  255  241  199  159  136  166  228  248  253  245  250  255
  253  253  253  253  253  253  253  253  255  248  249  255  159  123   94   78   24   40  174  237  254  251  190  208  188  181  171  164  169  186  209  226  255  254  156   40   27   68   88   95  174  238  255  250  255
  253  253  253  253  253  253  253  253  245  246  255  194  114  142  113   81   54    2    8  183  231  142  170  202  227  233  240  242  231  206  177  156  196  127   25    0   38   75  101  143  116  190  255  247  250
  252  252  252  252  252  252  252  252  255  251  238   96  124   91   22    0   11    0   15   85  174  244  255  247  252  246  241  241  244  246  243  239  207  104   11    0    6    0    0   73  108  135  233  248  255
  251  251  251  251  251  251  251  251  242  245  237   89  119   16    0    3    0    5   65  201  253  222  233  235  237  238  239  241  241  239  235  232  239  214  131   30    0   17   18    0   91   90  229  250  255
  251  251  251  251  251  251  251  251  251  253  208   70   54    0   15    0    0   77  208  232  225  247  234  241  236  239  240  238  233  231  234  237  222  247  222  118   15    0    4    5   53   63  239  245  245
  247  245  252  242  252  252  228  252  211  190  247   62    4    2    8    0   39  165  229  215  234  236  226  239  229  252  219  235  235  226  255  236  228  214  220  222   85    6    2    0   35   48  231  255  246
  252  252  216  222  228  241  252  208  119  252  222   79   38   51    0    5  103  206  231  238  240  255  253  248  255  229  254  233  252  241  240  223  228  248  219  200  175   45    0   43   12  125  255  255  244
  240  237  213  198  134  165  245  148  207  199  134  226  126   14    0   44  190  195  226  242  137   39   50   63  154  234  250  255  141   21    0   16  120  223  239  190  215   94    0   43  113  236  254  250  251
  252  252  236  239  249  193  149  177  198  185  222  193  135  123   79  115  185  196  226  116   22   56  129   84    3  175  236  152   22   78  114   74    0   86  197  213  203  146  111  129  238  255  231  249  255
  244  212  178  138  147  199  175   95  215  194  160  191  238  234  239  157  180  213  156    9   35  207  184  108   36   41  252   98   10   77  152  180   50    0   93  231  200  161  194  255  255  255  238  255  255
  236  225  202  233  232  179  166  159  169  209  220  218  202  229  234  168  198  194   38    5   77  158    0    0   57   81  255  145   73    0    0   89  129    8    8  186  206  162  193  255  249  236  250  255  240
  241  240  251  233  175  160  187  203  140  223  166  176  197  159  152  129  184  162    0    0   46  102   50  115  255  244  244  255  255  135   47  123   60    4    0  128  208  171  205  252  255  250  250  244  247
  251  251  238  143  182  219  145  219  175  123  193  175  153  182  191  151  208  127    9    0    5   47  199  255  165  134  169   88  152  255  213   66    1    2    4  124  206  153  219  249  248  255  252  253  255
  249  247  213  215  223  158  167  142  251  142  171  241  203  193  199  135  170  206   45    0    5   80  252  206    0   44  136   53    7  184  248  114    5    7   67  185  203  156  198  255  251  242  255  255  248
  243  251  244  233  153  196  143  217  218  216  148  202  177  148  163  162  164  186  211  170  119  157  214  223  122    2   12   21   99  251  220  175  121  177  215  205  184  139  255  243  255  247  250  253  255
  251  233  251  191  170  212  175  228  194  184  187  168  248  232  165  125  150  168  188  221  235  186  172  244  255  213  121  192  239  233  207  181  233  248  195  184  161  185  244  255  253  255  245  249  255
  251  236  247  174  239  212  231  190  181  171  251  182  210  251  251  234  141  183  173  184  206  168  162  209  232  245  216  255  247  224  167  195  229  187  188  175  125  255  251  235  228  255  255  252  255
  237  252  240  230  249  235  238  192  165  211  225  244  168  221  252  252  216  125  157  190  178  183  166  162  213  163  108  182  196  199  172  188  199  167  178  155  215  220  131  145  179  235  255  255  248
  244  252  249  247  241  252  219  212  174  240  241  205  107   88  114  205  255  177  138  174  185  188  195  156  138  124   66  154  160  164  217  193  191  193  154  174  189   78   16   97  128  173  247  255  243
  252  235  252  235  250  252  217  230  202  221  217  127  148  101   30   32  141  255  208  148  142  161  206  167  185  188  233  209  164  188  176  177  166  158  175  163    0    0   89  101  102  102  214  254  244
  246  248  249  252  245  244  224  252  222  252  156   81  101  117  107   28    0   73  172  161  142  156  151  183  173  174  167  173  176  177  185  152  159   85   79    7   12   25   86  123   97   56  186  252  246
  253  253  253  253  253  253  253  253  250  250  104   56   98  131   88   30   41   13    8   58  159  114  136  152  152  149  153  162  156  142  139  146  137  122   24   27   49   13   62  114   85   57  137  255  253
  253  253  253  253  253  253  253  253  254  235  130   30   73  127   88   40   50   44   45  123  197  186  173  160  149  153  157  155  153  159  175  191  200  204  122   42   41   14   63   88   69   37  182  241  255
  254  254  254  254  254  254  254  254  243  254  159   32   45   83  101   20   75   80   90  186  203  219  207  211  203  212  217  214  212  214  216  213  197  183  158   95   97   38   40   48    9   87  252  245  245
  254  254  254  254  254  254  254  254  255  242  237   78    3   31   27   58   66   63   98  196  186  201  204  223  216  206  197  196  202  208  211  211  205  219  195   67   22   27   23    8   62  197  255  255  230
  254  254  254  254  254  254  254  254  252  255  253  234  110   12   11   47   39   55  137  212  212  219  223  214  234  226  227  234  233  223  220  226  205  212  202  124   45   68   61   82  228  255  237  255  249
  254  254  254  254  254  254  254  254  246  230  255  255  228  189   75   55   40   95  211  236  229  235  255  243  241  248  255  255  254  242  240  246  255  245  250  219   77   64  126  255  255  245  255  236  255
  254  254  254  254  254  254  254  254  255  255  226  236  255  255  234  152   89   68   85   46   35   84  170  232  252  255  252  241  247  255  250  227  162  148  146  149  135  219  255  250  237  240  255  242  253
  254  254  254  254  254  254  254  254  247  255  255  249  255  238  255  254   61   14   49  101  118  100   63   71  228  249  254  248  255  240  147   40   48   44   52   45   59  165  255  252  254  255  234  255  250
  255  255  255  255  255  255  255  255  250  255  255  249  242  255  243   72   27  141  201  212  210  206  175   89   46  230  247  252  242  108   24  129  175  201  189  193  127    0  108  255  239  252  252  255  251
  255  255  255  255  255  255  255  255  255  255  253  253  253  252  149   12  111  166  174  165  159  165  167  124   41  107  255  249  159   21   97  144  150  164  183  170  178  121   45  151  253  255  250  253  253
  255  255  255  255  255  255  255  255  255  250  253  255  255  245   68   16  120  133  122  116  115  119  131  120   97   37  201  245   63   40  123  111  127  124  127  146  147  155   73   43  241  255  249  251  255
  255  255  255  255  255  255  255  255  253  250  255  253  255  240   30   69   75   82   85   91   93   91   93   89  109   49  151  223   10   71   86   97   97  100   91  103   83  109  102   24  200  252  252  252  255
  255  255  255  255  255  255  255  255  255  255  255  251  249  235   12   67   64   71   79   75   74   79   78   78   83   42  151  165   29   68   72   76   66   85   98   60   83   90   59   40  175  248  255  250  255
  255  255  255  255  255  255  255  255  255  252  248  255  253  246   32   29   50   53   66   56   56   68   62   65   63   37  172  171   36   53   67   48   60   65   63   57   79   55   64   21  193  253  255  249  251
  255  255  255  255  255  255  255  255  253  250  244  254  242  251   87   19   31   19   35   34   38   46   30   39   38   59  204  224   21   18   37   45   47   41   23   53   37   23   81   41  226  251  252  255  252
  255  255  255  255  255  255  255  255  251  255  246  245  213  235  128   30   46   11   15   14   20   23    5   24   57   59  176  204   62   29   23   10   12   20   40   20   14   49   27  114  245  241  241  255  255
  255  255  255  255  255  255  255  255  255  244  253  240  210  224  189   81   26   20   17   13    3    0   19   46   35   42   49   48   39   25   14    8    2    1    0    4   42   30   57  186  222  233  247  254  255
  255  255  255  255  255  255  255  255  255  247  255  251  221  228  225  177   76   50   30   30   38   44   54   65   97   96  100  109  109   86   45   11   30   40   46   25   30   76  150  241  232  241  251  255  255
  255  255  255  255  255  255  255  255  255  250  255  255  243  239  251  253  236  176  106   70   71   94  127  152  175  166  162  170  177  167  138  111   54   20   34   60  119  221  255  255  244  250  255  255  254
  255  255  255  255  255  255  255  255  255  252  249  255  255  252  249  255  255  255  252  251  248  241  238  241  223  222  220  220  222  227  231  233  243  204  219  236  244  255  255  235  251  254  255  255  253
  255  255  255  255  255  255  255  255  252  255  249  249  255  255  244  246  246  246  248  250  250  252  255  255  244  251  255  255  253  253  255  255  253  252  255  255  255  244  233  255  252  253  253  253  252];
image_data(:,:,2)=[254  254  254  254  254  254  254  254  255  235  251  255  236  255  242  255  255  255  234  255  255  242  255  242  255  253  251  253  255  255  251  246  255  249  250  253  248  251  255  251  243  245  255  255  241
  254  254  254  254  254  254  254  254  241  255  255  238  255  249  236  247  245  241  255  246  239  255  255  255  253  253  253  253  253  254  255  255  251  253  255  255  255  255  251  251  255  248  244  250  253
  254  254  254  254  254  254  254  254  255  255  236  254  255  226  195  180  172  215  255  255  252  253  254  235  248  254  255  255  254  250  249  251  250  255  241  199  159  136  166  228  248  253  245  250  255
  253  253  253  253  253  253  253  253  255  248  249  255  159  123   94   78   24   40  174  237  254  251  190  208  188  181  171  164  169  186  209  226  255  254  156   40   27   68   88   95  174  238  255  250  255
  253  253  253  253  253  253  253  253  245  246  255  194  114  142  113   81   54    2    8  183  231  142  170  202  227  233  240  242  231  206  177  156  196  127   25    0   38   75  101  143  116  190  255  247  250
  252  252  252  252  252  252  252  252  255  251  238   96  124   91   22    0   11    0   15   85  174  244  255  247  252  246  241  241  244  246  243  239  207  104   11    0    6    0    0   73  108  135  233  248  255
  253  253  253  253  253  253  253  253  244  247  239   91  121   18    1    5    0    5   65  201  253  222  233  235  237  238  239  241  241  239  235  232  239  214  131   30    0   17   18    0   91   90  229  250  255
  253  253  253  253  253  253  253  253  253  255  210   72   56    1   17    1    0   77  208  232  225  247  234  241  236  239  240  238  233  231  234  237  222  247  222  118   15    0    4    5   53   63  239  245  245
  252  250  255  247  255  255  233  255  216  195  252   67    9    7   13    1   39  165  229  215  234  236  226  239  229  252  219  235  235  226  255  236  228  214  220  222   85    6    2    0   35   48  231  255  246
  255  255  221  227  233  246  255  213  124  255  227   84   43   56    2   10  103  206  231  238  240  255  253  248  255  229  254  233  252  241  240  223  228  248  219  200  175   45    0   43   12  125  255  255  244
  245  242  218  203  139  170  250  153  212  204  139  231  131   19    5   49  190  195  226  242  137   39   50   63  154  234  250  255  141   21    0   16  120  223  239  190  215   94    0   43  113  236  254  250  251
  255  255  241  244  254  198  154  182  203  190  227  198  140  128   84  120  187  196  226  116   22   56  129   84    3  175  236  152   22   78  114   74    0   86  197  213  203  146  111  129  238  255  231  249  255
  251  219  185  145  154  206  182  102  222  201  167  198  245  241  246  162  182  213  156    9   35  207  184  108   36   41  252   98   10   77  152  180   50    0   93  231  200  161  194  255  255  255  238  255  255
  243  232  209  240  239  186  173  166  176  216  227  225  209  236  241  173  200  194   38    5   77  158    0    0   57   81  255  145   73    0    0   89  129    8    8  186  206  162  193  255  249  236  250  255  240
  248  247  255  240  182  167  194  210  147  230  173  183  204  166  159  134  186  162    0    0   46  102   50  115  255  244  244  255  255  135   47  123   60    4    0  128  208  171  205  252  255  250  250  244  247
  255  255  245  150  189  226  152  226  182  130  200  182  160  189  198  156  210  127    9    0    5   47  199  255  165  134  169   88  152  255  213   66    1    2    4  124  206  153  219  249  248  255  252  253  255
  255  254  220  222  230  165  174  149  255  149  178  248  210  200  206  140  172  206   45    0    5   80  252  206    0   44  136   53    7  184  248  114    5    7   67  185  203  156  198  255  251  242  255  255  248
  250  255  251  240  160  203  150  224  225  223  155  209  184  155  170  167  166  186  211  170  119  157  214  223  122    2   12   21   99  251  220  175  121  177  215  205  184  139  255  243  255  247  250  253  255
  255  240  255  198  177  219  182  235  201  191  194  175  255  239  172  130  152  168  188  221  235  186  172  244  255  213  121  192  239  233  207  181  233  248  195  184  161  185  244  255  253  255  245  249  255
  255  243  254  181  246  219  238  197  188  178  255  189  217  255  255  239  143  183  173  184  206  168  162  209  232  245  216  255  247  224  167  195  229  187  188  175  125  255  251  235  228  255  255  252  255
  242  255  245  235  254  240  243  197  170  216  230  249  173  226  255  255  218  125  157  190  178  183  166  162  213  163  108  182  196  199  172  188  199  167  178  155  215  220  131  145  179  235  255  255  248
  249  255  254  252  246  255  224  217  179  245  246  210  112   93  119  210  255  177  138  174  185  188  195  156  138  124   66  154  160  164  217  193  191  193  154  174  189   78   16   97  128  173  247  255  243
  255  240  255  240  255  255  222  235  207  226  222  132  153  106   35   37  141  255  208  148  142  161  206  167  185  188  233  209  164  188  176  177  166  158  175  163    0    0   89  101  102  102  214  254  244
  251  253  254  255  250  249  229  255  227  255  161   86  106  122  112   30    0   73  172  161  142  156  151  183  173  174  167  173  176  177  185  152  159   85   79    7   12   25   86  123   97   56  186  252  246
  255  255  255  255  255  255  255  255  252  252  106   58  100  133   90   32   41   13    8   58  159  114  136  152  152  149  153  162  156  142  139  146  137  122   24   27   49   13   62  114   85   57  137  255  253
  255  255  255  255  255  255  255  255  255  237  132   32   75  129   90   42   50   44   45  123  197  186  173  160  149  153  157  155  153  159  175  191  200  204  122   42   41   14   63   88   69   37  182  241  255
  254  254  254  254  254  254  254  254  243  254  159   32   45   83  101   20   75   80   90  186  203  219  207  211  203  212  217  214  212  214  216  213  197  183  158   95   97   38   40   48    9   87  252  245  245
  254  254  254  254  254  254  254  254  255  242  237   78    3   31   27   58   66   63   98  196  186  201  204  223  216  206  197  196  202  208  211  211  205  219  195   67   22   27   23    8   62  197  255  255  230
  254  254  254  254  254  254  254  254  252  255  253  234  110   12   11   47   39   55  137  212  212  219  223  214  234  226  227  234  233  223  220  226  205  212  202  124   45   68   61   82  228  255  237  255  249
  254  254  254  254  254  254  254  254  246  230  255  255  228  189   75   55   40   95  211  236  229  235  255  243  241  248  255  255  254  242  240  246  255  245  250  219   77   64  126  255  255  245  255  236  255
  254  254  254  254  254  254  254  254  255  255  226  236  255  255  234  152   89   68   85   46   35   84  170  232  252  255  252  241  247  255  250  227  162  148  146  149  135  219  255  250  237  240  255  242  253
  254  254  254  254  254  254  254  254  247  255  255  249  255  238  255  254   61   14   49  101  118  100   63   71  228  249  254  248  255  240  147   40   48   44   52   45   59  165  255  252  254  255  234  255  250
  255  255  255  255  255  255  255  255  250  255  255  249  242  255  243   72   27  141  201  212  210  206  175   89   46  230  247  252  242  108   24  129  175  201  189  193  127    0  108  255  239  252  252  255  251
  255  255  255  255  255  255  255  255  255  255  253  253  253  252  149   12  111  166  174  165  159  165  167  124   41  107  255  249  159   21   97  144  150  164  183  170  178  121   45  151  253  255  250  253  253
  255  255  255  255  255  255  255  255  255  250  253  255  255  245   68   16  120  133  122  116  115  119  131  120   97   37  201  245   63   40  123  111  127  124  127  146  147  155   73   43  241  255  249  251  255
  255  255  255  255  255  255  255  255  253  250  255  253  255  240   30   69   75   82   85   91   93   91   93   89  109   49  151  223   10   71   86   97   97  100   91  103   83  109  102   24  200  252  252  252  255
  255  255  255  255  255  255  255  255  255  255  255  251  249  235   12   67   64   71   79   75   74   79   78   78   83   42  151  165   29   68   72   76   66   85   98   60   83   90   59   40  175  248  255  250  255
  255  255  255  255  255  255  255  255  255  252  248  255  253  246   32   29   50   53   66   56   56   68   62   65   63   37  172  171   36   53   67   48   60   65   63   57   79   55   64   21  193  253  255  249  251
  255  255  255  255  255  255  255  255  253  250  244  254  242  251   87   19   31   19   35   34   38   46   30   39   38   59  204  224   21   18   37   45   47   41   23   53   37   23   81   41  226  251  252  255  252
  255  255  255  255  255  255  255  255  251  255  246  245  213  235  128   30   46   11   15   14   20   23    5   24   57   59  176  204   62   29   23   10   12   20   40   20   14   49   27  114  245  241  241  255  255
  255  255  255  255  255  255  255  255  255  244  253  240  210  224  189   81   26   20   17   13    3    0   19   46   35   42   49   48   39   25   14    8    2    1    0    4   42   30   57  186  222  233  247  254  255
  255  255  255  255  255  255  255  255  255  247  255  251  221  228  225  177   76   50   30   30   38   44   54   65   97   96  100  109  109   86   45   11   30   40   46   25   30   76  150  241  232  241  251  255  255
  255  255  255  255  255  255  255  255  255  250  255  255  243  239  251  253  236  176  106   70   71   94  127  152  175  166  162  170  177  167  138  111   54   20   34   60  119  221  255  255  244  250  255  255  254
  255  255  255  255  255  255  255  255  255  252  249  255  255  252  249  255  255  255  252  251  248  241  238  241  223  222  220  220  222  227  231  233  243  204  219  236  244  255  255  235  251  254  255  255  253
  255  255  255  255  255  255  255  255  252  255  249  249  255  255  244  246  246  246  248  250  250  252  255  255  244  251  255  255  253  253  255  255  253  252  255  255  255  244  233  255  252  253  253  253  252];
image_data(:,:,3)=[254  254  254  254  254  254  254  254  255  235  251  255  236  255  242  255  255  255  234  255  255  242  255  242  255  253  251  253  255  255  251  246  255  249  250  253  248  251  255  251  243  245  255  255  241
  254  254  254  254  254  254  254  254  241  255  255  238  255  249  236  247  245  241  255  246  239  255  255  255  253  253  253  253  253  254  255  255  251  253  255  255  255  255  251  251  255  248  244  250  253
  254  254  254  254  254  254  254  254  255  255  236  254  255  226  195  180  172  215  255  255  252  253  254  235  248  254  255  255  254  250  249  251  250  255  241  199  159  136  166  228  248  253  245  250  255
  253  253  253  253  253  253  253  253  255  248  249  255  159  123   94   78   24   40  174  237  254  251  190  208  188  181  171  164  169  186  209  226  255  254  156   40   27   68   88   95  174  238  255  250  255
  253  253  253  253  253  253  253  253  245  246  255  194  114  142  113   81   54    2    8  183  231  142  170  202  227  233  240  242  231  206  177  156  196  127   25    0   38   75  101  143  116  190  255  247  250
  252  252  252  252  252  252  252  252  255  251  238   96  124   91   22    0   11    0   15   85  174  244  255  247  252  246  241  241  244  246  243  239  207  104   11    0    6    0    0   73  108  135  233  248  255
  250  250  250  250  250  250  250  250  241  244  236   88  118   15    0    2    0    5   65  201  253  222  233  235  237  238  239  241  241  239  235  232  239  214  131   30    0   17   18    0   91   90  229  250  255
  250  250  250  250  250  250  250  250  250  252  207   69   53    0   14    0    0   77  208  232  225  247  234  241  236  239  240  238  233  231  234  237  222  247  222  118   15    0    4    5   53   63  239  245  245
  246  244  251  241  251  251  227  251  210  189  246   61    3    1    7    0   39  165  229  215  234  236  226  239  229  252  219  235  235  226  255  236  228  214  220  222   85    6    2    0   35   48  231  255  246
  251  251  215  221  227  240  251  207  118  251  221   78   37   50    0    4  103  206  231  238  240  255  253  248  255  229  254  233  252  241  240  223  228  248  219  200  175   45    0   43   12  125  255  255  244
  239  236  212  197  133  164  244  147  206  198  133  225  125   13    0   43  190  195  226  242  137   39   50   63  154  234  250  255  141   21    0   16  120  223  239  190  215   94    0   43  113  236  254  250  251
  251  251  235  238  248  192  148  176  197  184  221  192  134  122   78  114  184  196  226  116   22   56  129   84    3  175  236  152   22   78  114   74    0   86  197  213  203  146  111  129  238  255  231  249  255
  243  211  177  137  146  198  174   94  214  193  159  190  237  233  238  156  179  213  156    9   35  207  184  108   36   41  252   98   10   77  152  180   50    0   93  231  200  161  194  255  255  255  238  255  255
  235  224  201  232  231  178  165  158  168  208  219  217  201  228  233  167  197  194   38    5   77  158    0    0   57   81  255  145   73    0    0   89  129    8    8  186  206  162  193  255  249  236  250  255  240
  240  239  250  232  174  159  186  202  139  222  165  175  196  158  151  128  183  162    0    0   46  102   50  115  255  244  244  255  255  135   47  123   60    4    0  128  208  171  205  252  255  250  250  244  247
  250  250  237  142  181  218  144  218  174  122  192  174  152  181  190  150  207  127    9    0    5   47  199  255  165  134  169   88  152  255  213   66    1    2    4  124  206  153  219  249  248  255  252  253  255
  248  246  212  214  222  157  166  141  250  141  170  240  202  192  198  134  169  206   45    0    5   80  252  206    0   44  136   53    7  184  248  114    5    7   67  185  203  156  198  255  251  242  255  255  248
  242  250  243  232  152  195  142  216  217  215  147  201  176  147  162  161  163  186  211  170  119  157  214  223  122    2   12   21   99  251  220  175  121  177  215  205  184  139  255  243  255  247  250  253  255
  250  232  250  190  169  211  174  227  193  183  186  167  247  231  164  124  149  168  188  221  235  186  172  244  255  213  121  192  239  233  207  181  233  248  195  184  161  185  244  255  253  255  245  249  255
  250  235  246  173  238  211  230  189  180  170  250  181  209  250  250  233  140  183  173  184  206  168  162  209  232  245  216  255  247  224  167  195  229  187  188  175  125  255  251  235  228  255  255  252  255
  236  251  239  229  248  234  237  191  164  210  224  243  167  220  251  251  215  125  157  190  178  183  166  162  213  163  108  182  196  199  172  188  199  167  178  155  215  220  131  145  179  235  255  255  248
  243  251  248  246  240  251  218  211  173  239  240  204  106   87  113  204  255  177  138  174  185  188  195  156  138  124   66  154  160  164  217  193  191  193  154  174  189   78   16   97  128  173  247  255  243
  251  234  251  234  249  251  216  229  201  220  216  126  147  100   29   31  141  255  208  148  142  161  206  167  185  188  233  209  164  188  176  177  166  158  175  163    0    0   89  101  102  102  214  254  244
  245  247  248  251  244  243  223  251  221  251  155   80  100  116  106   27    0   73  172  161  142  156  151  183  173  174  167  173  176  177  185  152  159   85   79    7   12   25   86  123   97   56  186  252  246
  252  252  252  252  252  252  252  252  249  249  103   55   97  130   87   29   41   13    8   58  159  114  136  152  152  149  153  162  156  142  139  146  137  122   24   27   49   13   62  114   85   57  137  255  253
  252  252  252  252  252  252  252  252  253  234  129   29   72  126   87   39   50   44   45  123  197  186  173  160  149  153  157  155  153  159  175  191  200  204  122   42   41   14   63   88   69   37  182  241  255
  254  254  254  254  254  254  254  254  243  254  159   32   45   83  101   20   75   80   90  186  203  219  207  211  203  212  217  214  212  214  216  213  197  183  158   95   97   38   40   48    9   87  252  245  245
  254  254  254  254  254  254  254  254  255  242  237   78    3   31   27   58   66   63   98  196  186  201  204  223  216  206  197  196  202  208  211  211  205  219  195   67   22   27   23    8   62  197  255  255  230
  254  254  254  254  254  254  254  254  252  255  253  234  110   12   11   47   39   55  137  212  212  219  223  214  234  226  227  234  233  223  220  226  205  212  202  124   45   68   61   82  228  255  237  255  249
  254  254  254  254  254  254  254  254  246  230  255  255  228  189   75   55   40   95  211  236  229  235  255  243  241  248  255  255  254  242  240  246  255  245  250  219   77   64  126  255  255  245  255  236  255
  254  254  254  254  254  254  254  254  255  255  226  236  255  255  234  152   89   68   85   46   35   84  170  232  252  255  252  241  247  255  250  227  162  148  146  149  135  219  255  250  237  240  255  242  253
  254  254  254  254  254  254  254  254  247  255  255  249  255  238  255  254   61   14   49  101  118  100   63   71  228  249  254  248  255  240  147   40   48   44   52   45   59  165  255  252  254  255  234  255  250
  255  255  255  255  255  255  255  255  250  255  255  249  242  255  243   72   27  141  201  212  210  206  175   89   46  230  247  252  242  108   24  129  175  201  189  193  127    0  108  255  239  252  252  255  251
  255  255  255  255  255  255  255  255  255  255  253  253  253  252  149   12  111  166  174  165  159  165  167  124   41  107  255  249  159   21   97  144  150  164  183  170  178  121   45  151  253  255  250  253  253
  255  255  255  255  255  255  255  255  255  250  253  255  255  245   68   16  120  133  122  116  115  119  131  120   97   37  201  245   63   40  123  111  127  124  127  146  147  155   73   43  241  255  249  251  255
  255  255  255  255  255  255  255  255  253  250  255  253  255  240   30   69   75   82   85   91   93   91   93   89  109   49  151  223   10   71   86   97   97  100   91  103   83  109  102   24  200  252  252  252  255
  255  255  255  255  255  255  255  255  255  255  255  251  249  235   12   67   64   71   79   75   74   79   78   78   83   42  151  165   29   68   72   76   66   85   98   60   83   90   59   40  175  248  255  250  255
  255  255  255  255  255  255  255  255  255  252  248  255  253  246   32   29   50   53   66   56   56   68   62   65   63   37  172  171   36   53   67   48   60   65   63   57   79   55   64   21  193  253  255  249  251
  255  255  255  255  255  255  255  255  253  250  244  254  242  251   87   19   31   19   35   34   38   46   30   39   38   59  204  224   21   18   37   45   47   41   23   53   37   23   81   41  226  251  252  255  252
  255  255  255  255  255  255  255  255  251  255  246  245  213  235  128   30   46   11   15   14   20   23    5   24   57   59  176  204   62   29   23   10   12   20   40   20   14   49   27  114  245  241  241  255  255
  255  255  255  255  255  255  255  255  255  244  253  240  210  224  189   81   26   20   17   13    3    0   19   46   35   42   49   48   39   25   14    8    2    1    0    4   42   30   57  186  222  233  247  254  255
  255  255  255  255  255  255  255  255  255  247  255  251  221  228  225  177   76   50   30   30   38   44   54   65   97   96  100  109  109   86   45   11   30   40   46   25   30   76  150  241  232  241  251  255  255
  255  255  255  255  255  255  255  255  255  250  255  255  243  239  251  253  236  176  106   70   71   94  127  152  175  166  162  170  177  167  138  111   54   20   34   60  119  221  255  255  244  250  255  255  254
  255  255  255  255  255  255  255  255  255  252  249  255  255  252  249  255  255  255  252  251  248  241  238  241  223  222  220  220  222  227  231  233  243  204  219  236  244  255  255  235  251  254  255  255  253
  255  255  255  255  255  255  255  255  252  255  249  249  255  255  244  246  246  246  248  250  250  252  255  255  244  251  255  255  253  253  255  255  253  252  255  255  255  244  233  255  252  253  253  253  252];
set(handles.Image1,'CData',uint8(image_data));
image_data(:,:,1) = fliplr(image_data(:,:,1));
image_data(:,:,2) = fliplr(image_data(:,:,2));
image_data(:,:,3) = fliplr(image_data(:,:,3));
set(handles.Image2,'CData',uint8(image_data));


function JobStatusMonitorTBSSRandomise(hObject, eventdata, handles)

global TBSSRandomise_ResultPath;
global JobStatusMonitorTimerTBSSRandomise;
% global FileLocationPointer;
global F_Contrast_check;
global Group_check;

LogFile = [TBSSRandomise_ResultPath filesep 'tbss.log'];
fid = fopen(LogFile, 'r');
fseek(fid, -19, 1);
% fseek(fid, FileLocationPointer, 0);
% while ~feof(fid)
    OutputInformation = fgetl(fid);
    if ~isnumeric(OutputInformation)
        if strcmp(OutputInformation(1:8), 'Finished')
            set(handles.DesignButton, 'Enable', 'on');
            set(handles.Skeleton_Edit, 'Enable', 'on');
            set(handles.Skeleton_Button, 'Enable', 'on');
            set(handles.SkeletonMask_Edit, 'Enable', 'on');
            set(handles.SkeletonMask_Button, 'Enable', 'on');
            set(handles.DesignMatrix_Edit, 'Enable', 'on');
            set(handles.DesignMatrix_Button, 'Enable', 'on');
            set(handles.TContrast_Edit, 'Enable', 'on');
            set(handles.TContrast_Button, 'Enable', 'on');
            set(handles.F_Contrast_check, 'Enable', 'on');
            if F_Contrast_check
                set(handles.F_Contrast_check, 'Value', 1);
                set(handles.FContrast_Edit, 'Enable', 'on');
                set(handles.FContrast_Button, 'Enable', 'on');
            else
                set(handles.F_Contrast_check, 'Value', 0);
            end
            if Group_check
                set(handles.Group_check, 'Value', 1);
                set(handles.Group_Edit, 'Enable', 'on');
                set(handles.Group_Button, 'Enable', 'on');
            else
                set(handles.Group_check, 'Value', 0);
            end
            set(handles.PermutationTimes_Edit, 'Enable', 'on');
            set(handles.Prefix_Edit, 'Enable', 'on');
            set(handles.ResultPath_Edit, 'Enable', 'on');
            set(handles.ResultPath_Button, 'Enable', 'on');
            set(handles.TBSS_Statistic_Run, 'Enable', 'on');
            stop(JobStatusMonitorTimerTBSSRandomise);
            clear global JobStatusMonitorTimerTBSSRandomise;
        end
    end
% end
% FileLocationPointer = ftell(fid);


% --- Executes on button press in ClearButton.
function ClearButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_Skeleton;
global TBSSRandomise_SkeletonMask;
global TBSSRandomise_DesignMatrix;
global TBSSRandomise_TContrast;
global TBSSRandomise_FContrast;
global TBSSRandomise_Times;
global TBSSRandomise_Prefix;
global TBSSRandomise_ResultPath;
global F_Contrast_check;
global Group_check;
global TBSSRandomise_Group;
global JobStatusMonitorTimerTBSSRandomise;
global FileLocationPointer;

button = questdlg('Are you sure to Clear ?','Sure to Clear ?','Yes','No','Yes');
switch button
    case 'Yes'
        if ~isempty(JobStatusMonitorTimerTBSSRandomise)
            stop(JobStatusMonitorTimerTBSSRandomise);
            clear global JobStatusMonitorTimerTBSSRandomise;
        end
        
        set(handles.DesignButton, 'Enable', 'on');
        TBSSRandomise_Skeleton = '';
        set(handles.Skeleton_Edit, 'Enable', 'on');
        set(handles.Skeleton_Edit, 'String', '');
        set(handles.Skeleton_Button, 'Enable', 'on');
        TBSSRandomise_SkeletonMask = '';
        set(handles.SkeletonMask_Edit, 'Enable', 'on');
        set(handles.SkeletonMask_Edit, 'String', '');
        set(handles.SkeletonMask_Button, 'Enable', 'on');
        TBSSRandomise_DesignMatrix = '';
        set(handles.DesignMatrix_Edit, 'Enable', 'on');
        set(handles.DesignMatrix_Edit, 'String', '');
        set(handles.DesignMatrix_Button, 'Enable', 'on');
        TBSSRandomise_TContrast = '';
        set(handles.TContrast_Edit, 'Enable', 'on');
        set(handles.TContrast_Edit, 'String', '');
        set(handles.TContrast_Button, 'Enable', 'on');
        set(handles.F_Contrast_check, 'Enable', 'on');
        F_Contrast_check = 0;
        set(handles.F_Contrast_check, 'Value', 0);
        TBSSRandomise_FContrast = '';
        set(handles.FContrast_Edit, 'String', '');
        set(handles.FContrast_Edit, 'Enable', 'off');
        set(handles.FContrast_Button, 'Enable', 'off');
        Group_check = 0;
        set(handles.Group_check, 'Value', 0);
        TBSSRandomise_Group = '';
        set(handles.Group_Edit, 'String', '');
        set(handles.Group_Edit, 'Enable', 'off');
        set(handles.Group_Button, 'Enable', 'off');
        TBSSRandomise_Times = 5000;
        set(handles.PermutationTimes_Edit, 'Enable', 'on');
        set(handles.PermutationTimes_Edit, 'String', '5000');
        TBSSRandomise_Prefix = 'tbss';
        set(handles.Prefix_Edit, 'Enable', 'on');
        set(handles.Prefix_Edit, 'String', 'tbss');
        TBSSRandomise_ResultPath = '';
        set(handles.ResultPath_Edit, 'Enable', 'on');
        set(handles.ResultPath_Edit, 'String', '');
        set(handles.ResultPath_Button, 'Enable', 'on');
        FileLocationPointer = 0;
        set(handles.TBSS_Statistic_Run, 'Enable', 'on');
        set(handles.LoadButton, 'Enable', 'on');
    case 'No'
        return;
end


% --- Executes on button press in LoadButton.
function LoadButton_Callback(hObject, eventdata, handles)
% hObject    handle to LoadButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% global TBSSRandomise_OutputInfo_All;
global TBSSRandomise_Skeleton;
global TBSSRandomise_SkeletonMask;
global TBSSRandomise_DesignMatrix;
global TBSSRandomise_TContrast;
global TBSSRandomise_FContrast;
global TBSSRandomise_Group;
global TBSSRandomise_Times;
global TBSSRandomise_Prefix;
global TBSSRandomise_ResultPath;
global F_Contrast_check;
global Group_check;
if strcmp(get(handles.DesignButton, 'Enable'), 'off')
    msgbox('Please clear first !');
else
    LoadFlag = 1;
    [ParameterSaveFileName,ParameterSaveFilePath] = uigetfile({'*.PANDA_TBSSRandomise','TBSSRandomise-files (*.PANDA_TBSSRandomise)'},'Load Configuration');
    if ParameterSaveFileName ~= 0
        load([ParameterSaveFilePath ParameterSaveFileName], '-mat');
        set(handles.Skeleton_Edit, 'String', TBSSRandomise_Skeleton);
        set(handles.SkeletonMask_Edit, 'String', TBSSRandomise_SkeletonMask);
        set(handles.DesignMatrix_Edit, 'String', TBSSRandomise_DesignMatrix);
        set(handles.TContrast_Edit, 'String', TBSSRandomise_TContrast);
        if F_Contrast_check
            set(handles.F_Contrast_check, 'Value', 1);
            set(handles.FContrast_Edit, 'String', TBSSRandomise_FContrast);
        end
        if Group_check
            set(handles.Group_check, 'Value', 1);
            set(handles.Group_Edit, 'String', TBSSRandomise_Group);
        end
        set(handles.PermutationTimes_Edit, 'String', num2str(TBSSRandomise_Times));
        set(handles.Prefix_Edit, 'String', TBSSRandomise_Prefix);
        set(handles.ResultPath_Edit, 'String', TBSSRandomise_ResultPath);
        
        LogFile = [TBSSRandomise_ResultPath filesep 'tbss.log'];
        fid = fopen(LogFile, 'r');
        fseek(fid, -19, 1);
        OutputInformation = fgetl(fid);
        
        if ~isnumeric(OutputInformation)
            if ~strcmp(OutputInformation(1:8), 'Finished')
                set(handles.DesignButton, 'Enable', 'off');
                set(handles.Skeleton_Edit, 'Enable', 'off');
                set(handles.Skeleton_Button, 'Enable', 'off');
                set(handles.SkeletonMask_Edit, 'Enable', 'off');
                set(handles.SkeletonMask_Button, 'Enable', 'off');
                set(handles.DesignMatrix_Edit, 'Enable', 'off');
                set(handles.DesignMatrix_Button, 'Enable', 'off');
                set(handles.TContrast_Edit, 'Enable', 'off');
                set(handles.TContrast_Button, 'Enable', 'off');
                set(handles.F_Contrast_check, 'Enable', 'off');
                set(handles.FContrast_Edit, 'Enable', 'off');
                set(handles.FContrast_Button, 'Enable', 'off');
                set(handles.Group_check, 'Enable', 'off');
                set(handles.Group_Edit, 'Enable', 'off');
                set(handles.Group_Button, 'Enable', 'off');
                set(handles.PermutationTimes_Edit, 'Enable', 'off');
                set(handles.Prefix_Edit, 'Enable', 'off');
                set(handles.ResultPath_Edit, 'Enable', 'off');
                set(handles.ResultPath_Button, 'Enable', 'off');
                set(handles.LoadButton, 'Enable', 'off');
                set(handles.TBSS_Statistic_Run, 'Enable', 'off');

                % Start monitor function
                JobStatusMonitorTimerTBSSRandomise = timer( 'TimerFcn', {@JobStatusMonitorTBSSRandomise, handles}, 'period', 5, 'ExecutionMode', 'fixedRate');
                start(JobStatusMonitorTimerTBSSRandomise);
            end
        end
    end
end


% --- Executes during object creation, after setting all properties.
function figure1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in HelpButton.
function HelpButton_Callback(hObject, eventdata, handles)
% hObject    handle to HelpButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PANDA_Help;



function Group_Edit_Callback(hObject, eventdata, handles)
% hObject    handle to Group_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Group_Edit as text
%        str2double(get(hObject,'String')) returns contents of Group_Edit as a double
global TBSSRandomise_Group;
set(handles.Group_Edit, 'String', TBSSRandomise_Group);


% --- Executes during object creation, after setting all properties.
function Group_Edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Group_Edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
% end


% --- Executes on button press in Group_Button.
function Group_Button_Callback(hObject, eventdata, handles)
% hObject    handle to Group_Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_Group;
[Group_FileName, Group_ParentFolder] = uigetfile({'*.grp','contrast (*.grp)'},'Input group file');
if ~isnumeric(Group_FileName)
    TBSSRandomise_Group = [Group_ParentFolder Group_FileName];
    set(handles.Group_Edit, 'String', TBSSRandomise_Group);
end


% --- Executes on button press in Group_check.
function Group_check_Callback(hObject, eventdata, handles)
% hObject    handle to Group_check (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Group_check
global Group_check;
if get(hObject, 'value') == 1
    Group_check = 1;
    set(handles.Group_Edit, 'Enable', 'on');
    set(handles.Group_Button, 'Enable', 'on');
else
    Group_check = 0;
    set(handles.Group_Edit, 'Enable', 'off');
    set(handles.Group_Button, 'Enable', 'off');
end


% --- Executes on button press in StatusButton.
function StatusButton_Callback(hObject, eventdata, handles)
% hObject    handle to StatusButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global TBSSRandomise_ResultPath;
if exist([TBSSRandomise_ResultPath filesep 'tbss.log'], 'file')
    edit ([TBSSRandomise_ResultPath filesep 'tbss.log']);
end
