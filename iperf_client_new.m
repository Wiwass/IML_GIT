clear all

SERVERPORT= 23456;

Datatotransfer = input('Amount of data to transfer [kbyte]: ');

% Compute number of bytes to transfer (user inserts the number in kbytes)
BytesNum=Datatotransfer*1000;

% Manage connection error: if the server is busy, the connection request is
% rejected. The exception can be captured and handled using the TRY-CATCH
% paradigm. Errors raised by instructions in the TRY section are analyzed
% according to the CATCH instructions. 
connectionSuccessful = 0;
% Repeat until connection is accepted
while connectionSuccessful == 0    
    try
        C = tcpclient("localhost", SERVERPORT);
        connectionSuccessful = 1;
    % If a connection error is raised execute the following instructions
    catch ME  
        if strcmp(ME.identifier, 'MATLAB:networklib:tcpclient:cannotCreateObject')
            connectionSuccessful = 0;
            disp('wait')
        end
    end
end
disp('Connected to server')
% Specify byte ordering as "Little-Endian" 
% Same setting should be applied to the server side.
% Note: this is irreleant if data are represented as single bytes (uint8 or
% int8, char), while it is fundamental when using multi-byte formats
% (uint16, int16, double, ...)
C.ByteOrder = 'little-endian';

% Set waiting time to complete read and write operations
% If this time elapses before all data are transmitted, the client will
% stop the transmission anyway
C.Timeout = 60;

disp('Generating random data to transfer')
% generates a vector of "bytesize" random integers from 1 to 255
Data = randi(255,BytesNum,1);

% set the last byte to zero to inform the server application
% that the transmission is over
Data(end)=0;

disp('Transferring data to server')

% This function is blocking: the code will not proceed until all data are
% writted into the socket (i.e., transferred to the receiving buffer) or
% the timeout expires.
write(C,Data, 'uint8');

% The following function checks the actual number of data written into the
% socket. It should be equal to length(Data), but if the timeout expires
% beforehand, it might be lower. 
DataWritten =C.NumBytesWritten;
disp(['Total data transmitted: ',num2str(DataWritten/1e3),' kB'])
disp('Waiting for server reply')

% Read from the socket
speedmeasure = read(C,1,'double');
disp(['Measured upload speed [kbit/s]: ',num2str(speedmeasure)])
clear C