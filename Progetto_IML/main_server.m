clear all
disp('Server ready, waiting for connections...')
load("main_server_port.mat");
load("main_server_ip.mat");
S = tcpserver(main_server_ip, main_server_port);
S.ByteOrder = 'little-endian';

S.ConnectionChangedFcn = @server_function;



function server_function(S,~)

if S.Connected
    % disp('Connection OK!');
    disp(['Connected with Client with IP: ',S.ClientAddress,...
        ' at port number ',num2str(S.ClientPort)]);
    
    n=read(S,1,'uint8');
    switch n
        case 0  % key request
            
            key_length=read(S,1,"uint8");
            dataread=read(S,key_length,"uint8");
            serch_key=char(dataread);
            [db_key,ip,server_port]=serch_key_in_main_DB(serch_key);

            
            
            
            ip_length=length(ip);

            % data generation for arp request
            img=lavalamp();     
            p=DecBinToPrime(img);

            img=lavalamp();
            q=DecBinToPrime(img);
            
            e=3;

            %port generation
            load('host.mat');
            port=49152+mod(host*p*q,16383);
            save('host.mat','host');

            %% connessione al server di riferimento

            connectionSuccessful2 = 0;

            while connectionSuccessful2 == 0    
                try
                    C = tcpclient(ip,server_port);
                    C.ByteOrder = 'little-endian';
                    connectionSuccessful2 = 1;
                    % If connection to server fails, the instructions following "catch
                    % ME" are executed
                catch ME    
                
                    if strcmp(ME.identifier, 'MATLAB:networklib:tcpclient:cannotCreateObject')
                        connectionSuccessful2 = 1;
                        disp('wait: server not ready yet')
                    end
                end
            end

            if connectionSuccessful2==0
                write(S,0,'uint8');
                return
            else
                write(S,1,'uint8');
            end

            scale=4;
            %sending port number to the second server
            write(C,port,'int32');
            write(C,length(db_key),'int8');
            write(C,uint8(double(db_key)));
            write(C,scale,'uint8');
            write(C,p,'int32');
            write(C,q,'int32');
            write(C,e,'uint8');

            %%

            %data transmission to the client
            write(S,p,'int32');
            write(S,q,'int32');
            write(S,e,'uint8');
            write(S,ip_length,'uint8');
            write(S,ip);
            write(S,port,'uint32');

            disp("done");


        case 1 % key upload
            key_length=read(S,1,'uint8');
            dataread=read(S,key_length,'uint8');
            key=char(dataread);
            

            port=read(S,1,"uint32");

            ip_length=read(S,1,'uint8');
            dataread=read(S,ip_length,'uint8');
            ip=char(dataread);

            add_key_to_main_DB(key,ip,port);

            disp('Key uploaded');
            write(S,1,'uint8');

    end
            


           
    
else
    disp('Client disconnected')
end


end