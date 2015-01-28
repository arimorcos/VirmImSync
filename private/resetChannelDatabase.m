function resetChannelDatabase(configFile)
%resetChannelDatabase.m Resets channel database to only contain virmen and
%imaging
%
%INPUTS
%configFile - path to configuration file where user info is stored
%
%ASM 9/14

%load in userDatabase
load(configFile);

%create channel database
channelDatabase = {'virmen';...
                   'imaging'};

%save 
save(configFile,'userDatabase','channelDatabase')
