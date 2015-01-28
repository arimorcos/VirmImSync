function addMouse(user,mouse,configFile)
%addMouse.m Adds mouse to a given user
%
%INPUTS
%user - user to add mouse to
%mouse - mouse to add
%configFile - configuration file
%
%ASM 9/14

%load in config file
load(configFile,'userDatabase');

%Find user
userIndex = strcmpi(user,{userDatabase(:).user});

%Create new mouse
userDatabase(userIndex).mice = cat(1,userDatabase(userIndex).mice,{mouse});

%save 
save(configFile,'userDatabase');
