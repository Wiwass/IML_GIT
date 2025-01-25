clear all
disp('Server ready, waiting for connections...')
S = tcpserver("localhost", 23456);
S.ByteOrder = 'little-endian';
S.ConnectionChangedFcn = @server_function;



function server_function(S,~)


if S.Connected
    disp('Connection OK!');
    disp(['Connected with Client with IP: ',S.ClientAddress,...
        ' at port number ',num2str(S.ClientPort)]);
    

    port_number=read(S,'int8');
    key_length=read(S,'int8');
    im_id=read(S,key_length,'string');
    S2 = tcpserver("localhost", port_number);
    S2.ByteOrder = 'little-endian';
    S2.ConnectionChangedFcn = @server_function_2;



end
end

function server_function_2(S2,~)
    disp('Connection OK!');
    disp(['Connected with Client with IP: ',S.ClientAddress,...
        ' at port number ',num2str(S.ClientPort)]);
    filename=im_id;



end