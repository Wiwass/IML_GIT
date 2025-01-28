clear all
disp('Server ready, waiting for connections...')
load("main_server_port.mat");
load("main_server_ip.mat");
S = tcpserver(main_server_ip, main_server_port);
S.ByteOrder = 'little-endian';

S.ConnectionChangedFcn = @server_function;



function server_function(S,~)

if S.Connected
    disp('Connection OK!');
    disp(['Connected with Client with IP: ',S.ClientAddress,...
        ' at port number ',num2str(S.ClientPort)]);
    
    n=read(S,'int8');
    switch n
        case 0  % key request

            serch_key=read(S,20);
            [db_key,ip,server_port]=serch_key_in_DB(serch_key);
            ip_length=length(ip);

            % data generation for arp request
            img=lavaLamp();     
            p=DecBinToPrime(img);

            img=lavaLamp();
            q=DecBinToPrime(img);
            
            e=3;

            %port generation
            laod('host.mat');
            port=49152+mod(host*p*q,16383);
            save('host.mat','host');

            %% connessione al server di riferimento

            connectionSuccessful = 0;

            while connectionSuccessful == 0    
                try
                    C = tcpclient(ip,server_port);
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

            if db_key~='nf' OR connectionSuccessful==0
                write(S,0,'int8');
            else
                write(S,1,'int8');
                return;
            end
            write(C,0,'int8'); %sending port number to the second server
            write(C,port,'int32');
            write(C,lenth(db_key),'int8');
            write(C,db_key,'string');
            write(C,scale,'int8');
            write(C,p,'int32');
            write(C,q,'int32');
            write(C,e,'int8');

            %%

            %data transmission to the client
            write(S,p,'int32');
            write(S,q,'int32');
            write(S,e,'int8');
            write(S,ip_length,'int8');
            write(S,ip);
            write(S,port,'int32');


        case 1 % key upload
            key_length=read(S,'int8');
            key=read(S,key_length,'string');
            ip=S.ClientAddress;
            port=S.ClientPort;
            add_key_to_main_DB(key,ip,port);
            disp('Key uploaded');
            write(S,1,'int8');

    end
            


           
    
else
    disp('Client disconnected')
end


end