function handles = updateAxes(handles)
%updateAxes.m Updates axes for sync software
%
%INPUTS
%handles - structure of handles
%
%OUTPUTS 
%handles - structure of handles containing axis locations
%
%ASM 9/14

%set axis bounds in normalized coordinates
xOffset = [0.07 0.01];
yOffset = [0.07 0.09];
genPos = [xOffset(1)-0.015 yOffset(1)-0.015 (1-sum(xOffset)) (1-sum(yOffset))];


%delete current axes if they exist
if any(ishandle(handles.axH))
    delete(handles.axH);
end
if ishandle(handles.xlabel)
    delete(handles.xlabel);
end
if ishandle(handles.ylabel)
    delete(handles.ylabel);
end    

%initialize axes handles
handles.axH = gobjects(1,handles.nChannels);

%loop through each channel and create axis
for channelInd = 1:handles.nChannels
    
    %get positions
    pos = calcSubplotDivPositions(handles.nChannels,1,1,1,channelInd,...
        xOffset,yOffset,[0.01 0.01]);
    
    %create axis
    handles.axH(channelInd) = axes('Position',pos);
    
     
end

%remove xtick labels
set(handles.axH(1:end-1),'xticklabel',[]);

%set font to 20
set(handles.axH,'FontSize',20);

%set suplabels
[~,handles.ylabel] = suplabel('Voltage (V)','y',genPos);
[~,handles.xlabel] = suplabel('Time (s)','x',genPos);
set(handles.xlabel,'Fontsize',30);
set(handles.ylabel,'Fontsize',30);
