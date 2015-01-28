function resetConfigFile(configFile)
%resetConfigFile.m Function to reset config file
%
%INPUTS
%configFile - path to config file
%
%ASM 9/14

%create empty variable
userDatabase = [];

%save
save(configFile,'userDatabase');