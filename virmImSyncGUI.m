function varargout = virmImSyncGUI(varargin)
% VIRMIMSYNCGUI MATLAB code for virmImSyncGUI.fig
%      VIRMIMSYNCGUI, by itself, creates a new VIRMIMSYNCGUI or raises the existing
%      singleton*.
%
%      H = VIRMIMSYNCGUI returns the handle to a new VIRMIMSYNCGUI or the handle to
%      the existing singleton*.
%
%      VIRMIMSYNCGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VIRMIMSYNCGUI.M with the given input arguments.
%
%      VIRMIMSYNCGUI('Property','Value',...) creates a new VIRMIMSYNCGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before virmImSyncGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to virmImSyncGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help virmImSyncGUI

% Last Modified by GUIDE v2.5 23-Sep-2014 10:21:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @virmImSyncGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @virmImSyncGUI_OutputFcn, ...
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


% --- Executes just before virmImSyncGUI is made visible.
function virmImSyncGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to virmImSyncGUI (see VARARGIN)

% Choose default command line output for virmImSyncGUI
handles.output = hObject;

%initialize
handles.isRunning = false;
handles.configFile = [fileparts(mfilename('fullpath')),filesep,'virmImSyncConfig.mat'];
handles.userMenus = [];
handles.channelMenus = [];
handles.mouseMenus = [];
handles.currentUser = [];
handles.currentMouse = [];
handles.fileName = [];
handles.axH = [];
handles.xlabel = [];
handles.ylabel = [];
handles.acqNum = 1;

%set parameters
handles.refreshRate = 2;
handles.baseDir = 'C:\Data\Sync';

%label axes
% labelFont = 30;
% axes(handles.imAx);
% ylabel('Voltage','FontSize',labelFont);
% xlabel('Time (s)','FontSize',labelFont);
% axes(handles.virmenAx);
% ylabel('Voltage','FontSize',labelFont);
% set([handles.virmenAx handles.imAx],'Ytick',[],'xtick',[]);

%setup daq
% handles = setupSyncDAQSession(handles);

%update axes
handles.nChannels = 2;
handles = updateAxes(handles);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);



% UIWAIT makes virmImSyncGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = virmImSyncGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in acqButton.
function acqButton_Callback(hObject, eventdata, handles)
% hObject    handle to acqButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%change string for button
if handles.isRunning
    stop(handles.daq.s);
    set(hObject,'String','Start Acquisition');
    handles.acqNum = handles.acqNum + 1;
    
    %change isRunning state
    handles.isRunning = ~handles.isRunning;
    
    % Update handles structure
    guidata(hObject, handles);
    
    %update file name
    updateFileName(hObject, eventdata)
else
    %create matfile
    handles.saveFile = matfile(handles.fullFilePath);
    
    %create data array
    handles.saveFile.data = [];
    handles.saveFile.timeStamp = [];
    
    % Update handles structure
    guidata(hObject, handles);
    
    set(hObject,'String','Stop Acquisition');
    startBackground(handles.daq.s);
    
    %change isRunning state
    handles.isRunning = ~handles.isRunning;
    
    % Update handles structure
    guidata(hObject, handles);
end



function sampleRateEdit_Callback(hObject, eventdata, handles)
% hObject    handle to sampleRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of sampleRateEdit as text
%        str2double(get(hObject,'String')) returns contents of sampleRateEdit as a double

%get updated handles
handles = guidata(handles.figure1);

%get new rate
newRate = str2double(get(hObject,'String'));

%set rate
handles.daq.s.Rate = newRate;

handles.daq.s.NotifyWhenDataAvailableExceeds = round(newRate/handles.refreshRate);

% Update handles structure
guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function sampleRateEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sampleRateEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function setUserMenu_Callback(hObject, eventdata, handles)
% hObject    handle to setUserMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function setMouseMenu_Callback(hObject, eventdata, handles)
% hObject    handle to setMouseMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function addMouseMenu_Callback(hObject, eventdata, handles)
% hObject    handle to addMouseMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get new mouse name
newMouse = inputdlg('Input new mouse:','Add Mouse',1);

%add user
addMouse(handles.currentUser,newMouse{1},handles.configFile);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);


% --------------------------------------------------------------------
function addUserMenu_Callback(hObject, eventdata, handles)
% hObject    handle to addUserMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get new user name
newUser = inputdlg('Input new user:','Add User',1);

%add user
addUser(newUser{1},handles.configFile);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);

% --------------------------------------------------------------------
function removeMouseMenu_Callback(hObject, eventdata, handles)
% hObject    handle to removeMouseMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get new mouse name
mouseToRemove = inputdlg('Input mouse to remove:','Remove Mouse',1);

%remove mouse
removeMouse(handles.currentUser,mouseToRemove{1},handles.configFile);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);

% --------------------------------------------------------------------
function removeUserMenu_Callback(hObject, eventdata, handles)
% hObject    handle to removeUserMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get user name to remove
userToRemove = inputdlg('Input user to remove:','Remove User',1);

%add user
removeUser(userToRemove{1},handles.configFile);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);


% --------------------------------------------------------------------
function resetUsersMenu_Callback(hObject, eventdata, handles)
% hObject    handle to resetUsersMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%reset data
resetConfigFile(handles.configFile);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);

function updateMenus_Callback(hObject, eventdata, handles)

%get updated handles
handles = guidata(hObject);

%load config file
load(handles.configFile,'userDatabase','channelDatabase');

%process users
if ~isempty(userDatabase)
    
    %clear current menus
    if any(ishandle(handles.userMenus))
        delete(handles.userMenus);
        handles.userMenus = gobjects(0);
    end
    
    %get list of users
    userList = {userDatabase(:).user};
    
    %update menu with user list
    for userInd = length(userList):-1:1 %loop through each user and create menu
        handles.userMenus(length(handles.userMenus)+1)= uimenu(handles.setUserMenu,'Label',userList{userInd},...
            'Position',1,'Callback',@setCurrentUser_Callback);
    end
end

%process channels
if ~isempty(channelDatabase)
    
    %clear current menus
    if any(ishandle(handles.channelMenus))
        delete(handles.channelMenus);
        handles.channelMenus = gobjects(0);
    end
    
    %update menu with user list
    for channelInd = length(channelDatabase):-1:1 %loop through each user and create menu
        handles.channelMenus(length(handles.channelMenus)+1)= ...
            uimenu(handles.setChannelsMenu,'Label',channelDatabase{channelInd},...
            'Position',1);
    end
end

%update mouse menu if necessary
if ~isempty(handles.currentUser)
    
    %Find user
    userIndex = strcmpi(handles.currentUser,{userDatabase(:).user});
    
    %get mouse list
    mouseList = userDatabase(userIndex).mice;
    
    %clear current menus
    if any(ishandle(handles.mouseMenus))
        delete(handles.mouseMenus);
        handles.mouseMenus = gobjects(0);
    end
    
    %update menu with mouse list
    for mouseInd = length(mouseList):-1:1 %loop through each mouse and create menu
        handles.mouseMenus(length(handles.mouseMenus)+1) = ...
            uimenu(handles.setMouseMenu,'Label',mouseList{mouseInd},...
            'Position',1,'Callback',@setCurrentMouse_Callback);
    end
    
end
% Update handles structure
guidata(handles.figure1, handles);

function setCurrentUser_Callback(hObject, eventdata)

%get updated handles
handles = guidata(hObject);

%reset acq num
handles.acqNum = 1;

%get user name
userName = get(hObject,'Label');

%set current user
handles.currentUser = userName;

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);

function setCurrentMouse_Callback(hObject, eventdata)

%get updated handles
handles = guidata(hObject);

%reset acq num
handles.acqNum = 1;

%get user name
mouseName = get(hObject,'Label');

%set current mouse
handles.currentMouse = mouseName;

% Update handles structure
guidata(hObject, handles);

%update file name
updateFileName(hObject, eventdata)

function updateFileName(hObject, eventdata)

%get updated handles
handles = guidata(hObject);

%update file name
handles.fileName = sprintf('%s%s_%s_%03d',handles.currentUser,handles.currentMouse,...
    datestr(now,'yymmdd'),handles.acqNum);

%update file path
handles.filePath = sprintf('%s%s%s%s%s%s%s%s',handles.baseDir,filesep,...
    handles.currentUser,filesep,handles.currentUser,handles.currentMouse,...
    filesep,datestr(now,'yymmdd'));
handles.fullFilePath = sprintf('%s%s%s%s',handles.filePath,filesep,handles.fileName,'.mat');

%create directory
if ~exist(handles.filePath,'dir')
    mkdir(handles.filePath);
end

%update text box
set(handles.fileNameEdit,'String',handles.fileName);

% Update handles structure
guidata(hObject, handles);

%check if file name exists
if exist(handles.fullFilePath,'file')
    warndlg('File already exists. Adding new acquisition');
    
    %get list of files in filePath
    origDir = cd(handles.filePath);
    fileList = dir('*.mat');
    fileList = {fileList(:).name};
    cd(origDir);
    
    %get acquisition numbers
    acqNums = regexp(fileList,'(?<=\_)\d\d\d(?=\.mat)','match');
    acqNums = str2double(cat(1,acqNums{:}));

    %get max acquisition
    maxAcq = max(acqNums);
    
    %increment acqNum
    handles.acqNum = maxAcq + 1;
    
    % Update handles structure
    guidata(hObject, handles);
    
    updateFileName(hObject, eventdata)
end


function fileNameEdit_Callback(hObject, eventdata, handles)
% hObject    handle to fileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fileNameEdit as text
%        str2double(get(hObject,'String')) returns contents of fileNameEdit as a double


% --- Executes during object creation, after setting all properties.
function fileNameEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileNameEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function modifyParametersMenu_Callback(hObject, eventdata, handles)
% hObject    handle to modifyParametersMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function plotRefreshRate_Callback(hObject, eventdata, handles)
% hObject    handle to plotRefreshRate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get updated handles
handles = guidata(hObject);

%get new input
newRate = str2double(inputdlg('Input new plot refresh rate (Hz):','Set Plot Refresh Rate (Hz)',1));

%set 
handles.refreshRate = newRate;
handles.daq.s.NotifyWhenDataAvailableExceeds = ...
    round(str2double(get(handles.sampleRateEdit,'String'))/newRate);

% Update handles structure
guidata(hObject, handles);


% --------------------------------------------------------------------
function baseDir_Callback(hObject, eventdata, handles)
% hObject    handle to baseDir (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get updated handles
handles = guidata(hObject);

%get new input
newDir = inputdlg('Input new base directory:','Set Base Directory',1);

%set 
handles.baseDir = newDir;

% Update handles structure
guidata(hObject, handles);

%update file name
updateFileName(hObject, eventdata)


% --------------------------------------------------------------------
function addChannelMenu_Callback(hObject, eventdata, handles)
% hObject    handle to addChannelMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get new user name
newChannel = inputdlg('Input new channel:','Add Channel',1);

%add user
addChannelSync(newChannel{1},handles.configFile);

%update nChannels
handles.nChannels = handles.nChannels + 1;

%add channels
addAnalogInputChannel(handles.daq.s,handles.daq.deviceID,(handles.nChannels-1),'voltage');

%update axes
handles = updateAxes(handles);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);


% --------------------------------------------------------------------
function removeChannel_Callback(hObject, eventdata, handles)
% hObject    handle to removeChannel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%get user name to remove
channelToRemove = inputdlg('Input channel to remove:','Remove Channel',1);

%add user
channelIndex = removeChannelSync(channelToRemove{1},handles.configFile);

%update nChannels
handles.nChannels = handles.nChannels - 1;

%remove channels
removeChannel(handles.daq.s,(channelIndex-1));

%update axes
handles = updateAxes(handles);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);


% --------------------------------------------------------------------
function resetChannels_Callback(hObject, eventdata, handles)
% hObject    handle to resetChannels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%remove all channels
for i = 1:handles.nChannels
    removeChannel(handles.daq.s,i-1);
end

%reset channel database
resetChannelDatabase(handles.configFile);

%update nChannels
load(handles.configFile,'channelDatabase');
handles.nChannels = length(channelDatabase);

%add channels
addAnalogInputChannel(handles.daq.s,handles.daq.deviceID,0:(handles.nChannels-1),'voltage');

%update axes
handles = updateAxes(handles);

% Update handles structure
guidata(hObject, handles);

%update menus
updateMenus_Callback(hObject,eventdata,handles);


% --------------------------------------------------------------------
function setChannelsMenu_Callback(hObject, eventdata, handles)
% hObject    handle to setChannelsMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
