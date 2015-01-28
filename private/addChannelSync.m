function addChannelSync(channel,configFile)
%addChannelSync.m Function to add a new channel
%
%INPUTS
%channel - channel name to add
%configFile - path to configuration file
%
%ASM 9/14

%load in config file
load(configFile,'channelDatabase');

%Create new channel 
if isempty(channelDatabase)
    channelDatabase{1} = channel;
else
    %check if user already exists
    if any(strcmpi(channel,channelDatabase))
        error(sprintf('Channel %s already exists',channel));
    end   
    
    channelDatabase = cat(1,channelDatabase,channel);
end

%save 
save(configFile,'channelDatabase','-append');