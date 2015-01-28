function handles = setupSyncDAQSession(handles)
%setupSyncDAQSession.m Sets up daq session for sync
%
%INPUTS
%handles - handles structure
%
%OUTPUTS
%handles - handles structure with daq objects
%
%ASM 9/14

%create session
handles.daq.s = daq.createSession('ni');

%get device info
handles.daq.deviceInfo = daq.getDevices;
handles.daq.deviceID = handles.daq.deviceInfo.ID;

%get number of channels
load(handles.configFile,'channelDatabase');
handles.nChannels = length(channelDatabase);

%add channels
addAnalogInputChannel(handles.daq.s,handles.daq.deviceID,0:(handles.nChannels-1),'voltage');

%add listener
handles.daq.listener = addlistener(handles.daq.s,'DataAvailable', @(src,event) plotSyncData(src,event,handles.figure1)); 

%set to continuous
handles.daq.s.IsContinuous = true;

%plot after same number as sample rate
handles.daq.s.NotifyWhenDataAvailableExceeds = round(str2double(get(handles.sampleRateEdit,'String'))/handles.refreshRate);