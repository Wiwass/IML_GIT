clear all

serch_key = '???';

load("main_server_port.mat");
load("main_server_ip.mat");

connectionSuccessful = 0;
while connectionSuccessful == 0    
    try
        C = tcpclient(main_server_ip, main_server_port);
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

connectionSuccessful = 0;
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
x_size=read(C,'int32');
y_size=read(C,'int32');
stream=read(C,x_size*scale*y_size*scale,'int8');
cripted_img = reshape(stream,x_size*scale,y_size*scale);
output_img=fft_decriptation(cripted_img,scale,p,q);
img=ifft2(output_img);
im_show(img);