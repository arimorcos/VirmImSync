function channelIndex = removeChannelSync(channel,configFile)
%removeChannelSync.m Removes channel from config file 
%
%INPUTS
%channel - string containing channel to remove
%configFile - path to configuration file where user info is stored
%
%OUTPUTS
%channelIndex - index of removed channel
%
%ASM 9/14


%load in config file
load(configFile,'channelDatabase');

%Find user
channelIndex = strcmpi(channel,channelDatabase);

%check if empty
if ~any(channelIndex) 
    error(sprintf('Channel %s not found',channel));
end

%remove user
channelDatabase(channelIndex) = [];

%save 
save(configFile,'channelDatabase','-append');
