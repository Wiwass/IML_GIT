% function definition. The first parameter is assigned the handle of the 
% TCPserver object that calls the function. The other parameters are 
% neglected (~)
function funmyuc(S,~)


if S.Connected
    disp('Connection OK!');
    disp(['Connected with Client with IP: ',S.ClientAddress,...
        ' at port number ',num2str(S.ClientPort)]);
           % Read number of bytes to read (string length)
        dim = read(S,1,'uint8') ;

        % Read  "dim" bytes from the pipe 
        dataread = read(S,dim,'uint8');
        
        % convert bytes into ASCII characters
        lowerstring = char(dataread);
        upperstring  = upper(lowerstring);
        % Send the uppercase version of the string to the client
        write(S,uint8(double(upperstring)));
        disp('String converted and returned to the client')
    
else
    disp('Client disconnected')
end
