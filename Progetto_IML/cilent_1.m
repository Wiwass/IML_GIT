clear all

serch_key = 'U2NyZWVuc2hvdCAyMDIzLTA3LTI3IDEwMjAzMS5wbmc=';  % Search key

load("main_server_port.mat");  % Load the main server port number
load("main_server_ip.mat");    % Load the main server IP address
number = 6;
offset = nthprime(number);  % Calculate the offset using the nth prime number

connectionSuccessful = 0;
while connectionSuccessful == 0    
    try
        C = tcpclient(main_server_ip, main_server_port, "Timeout", 60);  % Create a TCP client
        C.ByteOrder = 'little-endian';  % Set byte order
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

write(C, 0, 'uint8');  % Key request

pk = read(C, 2, 'int32');  % Read RSA public key
n = double(pk(1));
e = double(pk(2));

crip_key = RSA_enc(char(serch_key), n, e);  % Encrypt the search key
crip_offset = RSA_enc(char(offset), n, e);  % Encrypt the offset

write(C, length(crip_key), "int8");
write(C, int32(double(crip_key)));  % Send the encrypted key to the server

write(C, crip_offset, "int32");  % Send the encrypted offset to the server

exists = read(C, 1, 'int8');  % Server response

if exists == 1
    % Acquisition of the key information
    disp('Key found')
    p = read(C, 1, 'int32');
    q = read(C, 1, 'int32');
    ip_length = read(C, 1, 'uint8');
    dataread = read(C, ip_length);
    ip = char(dataread);
    port = read(C, 1, 'int32');
else
    disp('Key not found')
    return;
end

clear C

connectionSuccessful = 0;
disp("connecting to external server");
pause(5);
while connectionSuccessful == 0    
    try
        C2 = tcpclient(ip, port);  % Create a TCP client for the external server
        C2.ByteOrder = 'little-endian';  % Set byte order
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
% Receive the image informations
scale = uint8(read(C2, 1, 'uint8'));
scale = uint32(scale);
x_size = int32(read(C2, 1, 'int32'));
y_size = int32(read(C2, 1, 'int32'));

% Preallocate matrices
realstream = zeros(y_size, x_size, 'double');
imagstream = zeros(y_size, x_size, 'double');
cripted_img = complex(zeros(y_size, x_size));

% Read data
for i = 1:y_size
    realstream(i,:) = read(C2, x_size, 'double');
end

for i = 1:y_size
    imagstream(i,:) = read(C2, x_size, 'double');
end

% Reconstruct complex matrix
cripted_img = complex(realstream, imagstream);

p = int32(p * offset);
q = int32(q * offset);
output_img = fft_decriptation(cripted_img, scale, p, q);  % Decrypt the image using FFT

img = ifft2(output_img);  % Perform inverse FFT
img = uint8(img);
toc
imshow(img);  % Display the image
