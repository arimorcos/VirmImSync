function addUser(user,configFile)
%addUser.m Adds user to config file 
%
%INPUTS
%user - string containing user ID
%configFile - path to configuration file where user info is stored
%
%ASM 9/14


%load in config file
load(configFile,'userDatabase');

%Create new structure 
if isempty(userDatabase)
    userDatabase(1).user = user;
    userDatabase(1).mice = {};
else
    %check if user already exists
    if any(strcmpi(user,{userDatabase(:).user}))
        error(sprintf('User %s already exists',user));
    end   
    
    userDatabase(length(userDatabase)+1).user = user;
    userDatabase(length(userDatabase)).mice = {};
end

%save 
save(configFile,'userDatabase');
