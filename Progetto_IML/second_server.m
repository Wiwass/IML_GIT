clear all

global x_size y_size cripted_img offset;
disp('Server ready, waiting for connections...')

load("second_server_port.mat");  % Load the second server port number
load("second_server_ip.mat");    % Load the second server IP address
S = tcpserver(second_server_ip, second_server_port);  % Create a TCP server
S.ByteOrder = 'little-endian';  % Set byte order
S.ConnectionChangedFcn = @server_function;  % Set the connection change callback function

function server_function(S,~)
    if S.Connected
        % Connection established
        disp('Connection OK!');
        disp(['Connected with Client with IP: ', S.ClientAddress, ...
              ' at port number ', num2str(S.ClientPort)]);
        
        load("second_server_ip.mat");
        
        port_number = read(S, 1, 'int32');  % Read the port number
        key_length = read(S, 1, 'uint8');  % Read the key length
        dataread = read(S, key_length, 'uint8');  % Read the key data
        im_id = char(dataread);  % Convert the key data to a string
        scale = read(S, 1, 'uint8');  % Read the scale
        p = read(S, 1, 'int32');  % Read the first prime number
        q = read(S, 1, 'int32');  % Read the second prime number

        filename = get_filename(im_id);  % Get the filename based on the key
        cd assets\immages;
        img = imread(filename);  % Read the image
        img = im2gray(img);  % Convert the image to grayscale
        cd ..;
        cd ..;
        
        img = fft2(img);  % Perform FFT on the image
        cripted_img = fft_criptation(img, scale, p, q);  % Encrypt the image using FFT
        [y_size, x_size] = size(cripted_img);  % Get the size of the encrypted image

        S2 = tcpserver(second_server_ip, port_number);  % Create a second TCP server
        S2.ByteOrder = 'little-endian';  % Set byte order

        done = 0;  % Initialize the done flag
        tic
        while toc < 60
            pause(0.5);
            if S2.Connected == 1
                server_function_2(S2, cripted_img, x_size, y_size, scale);  % Call the second server function
                done = 1;
                break;
            end
        end

        if done == 1
            disp("done");
        else
            disp("timeout reached");
        end
    end
end

function server_function_2(S2, cripted_img, x_size, y_size, scale)
    disp('Connection OK!');
    disp(['Connected with Client with IP: ', S2.ClientAddress, ...
          ' at port number ', num2str(S2.ClientPort)]);

    % Ensure byte order consistency
    S2.ByteOrder = 'little-endian';

    % Preallocate linebuffer for better performance
    linebuffer = zeros(1, x_size, 'double');

    % Send dimensions first
    write(S2, uint8(scale), 'uint8');
    write(S2, int32(x_size), 'int32');
    write(S2, int32(y_size), 'int32');

    % Send real and imaginary parts separately
    for i = 1:y_size
        linebuffer = real(cripted_img(i,:));
        write(S2, linebuffer, 'double');
    end

    for i = 1:y_size
        linebuffer = imag(cripted_img(i,:));
        write(S2, linebuffer, 'double');
    end
end