function removeUser(user,configFile)
%addUser.m Removes user from config file 
%
%INPUTS
%user - string containing user ID
%configFile - path to configuration file where user info is stored
%
%ASM 9/14


%load in config file
load(configFile,'userDatabase');

%Find user
userIndex = strcmpi(user,{userDatabase(:).user});

%check if empty
if ~any(userIndex) 
    error(sprintf('User %s not found',user));
end

%remove user
userDatabase(userIndex) = [];

%save 
save(configFile,'userDatabase');
