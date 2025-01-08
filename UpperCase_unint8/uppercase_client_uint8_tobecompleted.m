%Instructions marked by ??? need to be completed by the student
clear all

mystr = input('Input ASCII string to convert into uppercase (only numbers and standard letters): ','s');

connectionSuccessful = 0;
% connection error handling in case of multiple clients insisting on the
% same server (necessary due to MATLAB's inability to handle parallel
% threads  
%
% keep trying until success
while connectionSuccessful == 0    
    try
        C = tcpclient("localhost", 1238);
        C.ByteOrder = 'little-endian';
        connectionSuccessful = 1;
        % If connection to server fails, the instructions following "catch
        % ME" are executed
    catch ME    
        % Check the type of error
        if strcmp(ME.identifier, 'MATLAB:networklib:tcpclient:cannotCreateObject')
            connectionSuccessful = 0;
            disp('wait: server not ready yet')
        end
    end
end


% Since the message length will be encoded with one single byte, the string
% cannot be longer than 255 charatcers. If it is longer, it must be
% truncated to 255 characters. If you wish to design a protocol that
% accepts longer strings, then the mechanism to indicate the string length
% at the server should be revised (e.g., you can use the command writeline,
% or use a double in place of a singly byte to encode the message length,
% or other techniques.
dim = length(mystr);
if dim > 255
    dim=255;
    disp('String too long! Truncated to 255 characters...')
    mystr=convertStringsToChars(mystr);
    mystr=mystr(1:255);
    mystr=convertCharsToStrings(mystr);
end

% The variable mystr is a "STRING", i.e., a vector of CHARS. Each CHAR is
% nothing else than a byte, whose value is represented as a printable ASCII
% character rather than a binary digit. By setting the variable type to
% STRING we just instruct MATLAB to interpret the binary values as
% ASCII codewords. 
% The "write" command of MATLAB sends the data with the type of the
% variable. In this case, as charaters. However, the receiver is programmed
% to read bytes as UINT8. Is this a problem? 
% In this specific case, it is not a problem because, as we said, a CHAR is
% nothing else than a byte whose value is interpreted by the application as
% and ASCII character. If the server reads byte by byte and interprets each
% byte as the codewords of an ASCII character there is not ambiguity. 
% Things would be different if the transmitted data were coded, e.g., as
% UNIT16 and read as UNIT 8. 

% We now need to send into the pipe a byte indicating the string lenght

% Send the string length to the server
write(C,dim,'uint8');

% Send the bytes corresponding to the string characters
write(C,mystr)

% Read the bytes returned by the server


uppercasestring = read(C,dim);

% Cast the bytes into CHAR in order to diplay them as a string
disp(['Upper case string:', char(uppercasestring)])
% Close the socket
clear C
