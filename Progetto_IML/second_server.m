clear all

global x_size y_size cripted_img offset;
disp('Server ready, waiting for connections...')

load("second_server_port.mat");
load("second_server_ip.mat");
S = tcpserver(second_server_ip, second_server_port);
S.ByteOrder = 'little-endian';
S.ConnectionChangedFcn = @server_function;



function server_function(S,~)


if S.Connected
    disp('Connection OK!');
    disp(['Connected with Client with IP: ',S.ClientAddress,...
        ' at port number ',num2str(S.ClientPort)]);
    
    load("second_server_ip.mat");
    
    port_number=read(S,1,'int32');
    key_length=read(S,1,'uint8');
    dataread=read(S,key_length,'uint8');
    im_id=char(dataread);
    scale=read(S,1,'uint8');
    p=read(S,1,'int32');
    q=read(S,1,'int32');


    filename=get_filename(im_id);
    cd assets\immages;
    img=imread(filename);
    img=im2gray(img);
    cd ..;
    cd ..;
    
    img=fft2(img);
    cripted_img=fft_criptation(img,scale,p,q);
    [y_size,x_size]=size(cripted_img);


    S2 = tcpserver(second_server_ip, port_number);
    S2.ByteOrder = 'little-endian';

    done = 0; % Aggiungi questa riga
    tic
    while toc<60
        pause(0.5);
        if S2.Connected==1
            server_function_2(S2,cripted_img,x_size,y_size,scale);
            done=1;
            break;
        end
    end

    if done==1
        disp("done");
    else
        disp("timeout reached");
    end

end
end

function server_function_2(S2,cripted_img,x_size,y_size,scale)
    disp('Connection OK!');
    disp(['Connected with Client with IP: ',S2.ClientAddress,...
        ' at port number ',num2str(S2.ClientPort)]);

    % Assicurati che il ByteOrder sia consistente
    S2.ByteOrder = 'little-endian';

    % Preallocare linebuffer per migliori performance
    linebuffer = zeros(1, x_size, 'double');

    % Invia prima le dimensioni
    write(S2, uint8(scale), 'uint8');
    write(S2, int32(x_size), 'int32');
    write(S2, int32(y_size), 'int32');

    % Invia parte reale e immaginaria separate
    for i = 1:y_size
        linebuffer = real(cripted_img(i,:));
        write(S2, linebuffer, 'double');
    end

    for i = 1:y_size
        linebuffer = imag(cripted_img(i,:));
        write(S2, linebuffer, 'double');
    end

end