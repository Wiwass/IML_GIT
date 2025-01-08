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

    tic;
    conta=1;

    while(1)
        temp=read(S,1,'uint8');
        if(temp==0)
            break;
        end
        conta=conta+1;
    end
    
    close=toc;
    speed=(conta/1000)/close;
    write(S,double(speed),'double');
           
    
else
    disp('Client disconnected')
end


end