clear all

serch_key = 'U2NyZWVuc2hvdCAyMDIzLTA3LTI3IDEwMjAzMS5wbmc=';

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

write(C,0,'uint8'); % key request
write(C,length(serch_key),"int8");
write(C,uint8(double(serch_key)));

exists=read(C,1,'int8');

if exists==1
    % aquisition of the key informations
    disp('Key found')
    p=read(C,1,'int32');
    q=read(C,1,'int32');
    e=read(C,1,'uint8');
    ip_length=read(C,1,'uint8');
    dataread=read(C,ip_length);
    ip=char(dataread);
    port=read(C,1,'int32');
else
    disp('Key not found')
    return;
end

clear C

connectionSuccessful = 0;
disp("connecting to external server");
while connectionSuccessful == 0    
    try
        C2 = tcpclient(ip, port);
        C2.ByteOrder = 'little-endian';
        connectionSuccessful = 1;
        disp("connected");
        % If connection to server fails, the instructions following "catch
        % ME" are executed
    catch ME    
        if strcmp(ME.identifier, 'MATLAB:networklib:tcpclient:cannotCreateObject')
            connectionSuccessful = 1;
            disp('wait: server not ready yet')
        end
    end
end

tic
%receive the image
scale = uint8(read(C2, 1, 'uint8'));
scale = uint32(scale);
x_size = int32(read(C2, 1, 'int32'));
y_size = int32(read(C2, 1, 'int32'));

% Preallocazione matrici
realstream = zeros(y_size, x_size, 'double');
imagstream = zeros(y_size, x_size, 'double');
cripted_img = complex(zeros(y_size, x_size));

% Lettura dati
for i = 1:y_size
    realstream(i,:) = read(C2, x_size, 'double');
end

for i = 1:y_size
    imagstream(i,:) = read(C2, x_size, 'double');
end

% Ricostruzione matrice complessa
cripted_img = complex(realstream, imagstream);

output_img=fft_decriptation(cripted_img,scale,p,q);
output_img=uint8(output_img);

img=ifft2(output_img);
toc
imshow(img);
