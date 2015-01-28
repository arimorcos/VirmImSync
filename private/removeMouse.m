function removeMouse(user,mouse,configFile)
%removeMouse.m Removes mouse from a given user
%
%INPUTS
%user - user to remove mouse from
%mouse - mouse to remove
%configFile - configuration file
%
%ASM 9/14

%load in config file
load(configFile,'userDatabase');

%Find user
userIndex = strcmpi(user,{userDatabase(:).user});

%find mouse
mouseIndex = strcmpi(mouse,userDatabase(userIndex).mice);

%Remove mouse
userDatabase(userIndex).mice(mouseIndex) = [];

%save 
save(configFile,'userDatabase');
