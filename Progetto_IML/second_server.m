clear all

global x_size y_size cripted_img;
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
    

    port_number=read(S,'int32');
    key_length=read(S,'int8');
    im_id=read(S,key_length,'string');
    scale=read(S,'int8');
    p=read(S,'int32');
    q=read(S,'int32');
    e=read(S,'int8');
    filename=get_filename(im_id);
    img=imread(filename);
    [x_size,y_size]=size(img);
    cripted_img=fft_criptation(filename,scale,p,q);


    S2 = tcpserver("localhost", port_number);
    S2.ByteOrder = 'little-endian';
    S2.ConnectionChangedFcn = @server_function_2;



end
end

function server_function_2(S2,~)
    disp('Connection OK!');
    disp(['Connected with Client with IP: ',S.ClientAddress,...
        ' at port number ',num2str(S.ClientPort)]);

    
    write(S2,scale,'int8');
    write(S2,x_size,'int32');
    write(S2,y_size,'int32');
    write(S2,cripted_img,'int8'); 
    



end