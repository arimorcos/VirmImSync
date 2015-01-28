function plotSyncData(hObject,event,figH)

%get updated handles
handles = guidata(figH);

%% plot

%loop through each channel
for channelInd = 1:handles.nChannels
    
    %set proper axis
    axes(handles.axH(channelInd)); %#ok<LAXES>
    
    %plot
    plot(event.TimeStamps, event.Data(:,channelInd));
    
end

%remove xtick
set(handles.axH(1:end-1),'xticklabel',[]);

%% store data

%store 
handles.saveFile.data = cat(2,handles.saveFile.data,single(event.Data)');
handles.saveFile.timeStamp = cat(2,handles.saveFile.timeStamp,single(event.TimeStamps)');

% Update handles structure
guidata(figH, handles);
