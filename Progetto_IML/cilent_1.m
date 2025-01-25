clear all

serch_key = '???';

connectionSuccessful = 0;

while connectionSuccessful == 0    
    try
        C = tcpclient("localhost", 1238);
        C.ByteOrder = 'little-endian';
        connectionSuccessful = 1;
        % If connection to server fails, the instructions following "catch
        % ME" are executed
    catch ME    
       
        if strcmp(ME.identifier, 'MATLAB:networklib:tcpclient:cannotCreateObject')
            connectionSuccessful = 1;
            disp('wait: server not ready yet')
        end
    end
end


write(C,0,'int8'); % key request
write(C,serch_key); 

exists=read(C,'int8');

if exists==1
    % aquisition of the key informations
    disp('Key found')
    p=read(C,'int32');
    q=read(C,'int32');
    e=read(C,'int8');
    ip_length=read(C,'int8');
    ip=read(C,ip_length,'string');
    port=read(C,'int8');
else
    disp('Key not found')
end

clear C


while connectionSuccessful == 0    
    try
        C = tcpclient(ip, port);
        C.ByteOrder = 'little-endian';
        connectionSuccessful = 1;
        % If connection to server fails, the instructions following "catch
        % ME" are executed
    catch ME    
       
        if strcmp(ME.identifier, 'MATLAB:networklib:tcpclient:cannotCreateObject')
            connectionSuccessful = 1;
            disp('wait: server not ready yet')
        end
    end
end

%receive the image
scale=read(C,'int8');
size=read(C,'int32');
img=read(C,size*scale*size*scale,'int8');
output_img=fft_decriptation(img,scale,p,q);
output_img=ifft2(output_img);
im_show(output_img);