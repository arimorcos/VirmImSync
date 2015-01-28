%%

%create session
currSess = daq.createSession('ni');

%get device info
deviceInfo = daq.getDevices;
deviceID = deviceInfo.ID;

%add channels
addAnalogInputChannel(currSess,deviceID,0:1,'voltage');

%add listener
lh = addlistener(currSess,'DataAvailable', @testPlotData); 

%set to continuous
currSess.IsContinuous = true;
%% start listening

startBackground(currSess);

%% stop listening
stop(currSess);