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
    
    whattodo=read(S,1,'uint8');
    switch whattodo
        case 0  % key request

            p=LavaLampToPrime1();
            q=LavaLampToPrime1();

            while p==q
                q=LavaLampToPrime1();
            end

            
            [n,e,d]=RSA_key_gen(p,q);
            write(S,[n,e],"int32");
            n=double(n);
            e=double(e);
            d=double(d);
            
            crip_key_length=read(S,1,"uint8");
            crip_serch_key=read(S,crip_key_length,"uint32");
            crip_offset=read(S,1,"int32");

            offset=RSA_dec(crip_offset,d,n);
            serch_key=RSA_dec(crip_serch_key,d,n);
            serch_key=char(serch_key);

            [db_key,ip,server_port]=serch_key_in_main_DB(serch_key);

            ip_length=length(ip);

            % prime generation for the data transmission
            p=LavaLampToPrime1();
            q=LavaLampToPrime1();

            while p==q
                q=LavaLampToPrime1();
            end

            %port generation
            load('host.mat');
            port=49152+mod(host*p*q,16383);
            save('host.mat','host');

            %% connessione al server di riferimento

            connectionSuccessful2 = 0;

            if size(char(db_key))==size(char('nf'))
                if char(db_key)==char('nf')
                    write(S,0,"uint8");
                end
            end

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
            write(C,p*offset,'int32');
            write(C,q*offset,'int32');

            %%

            %data transmission to the client
            write(S,p,'int32');
            write(S,q,'int32');
            write(S,ip_length,'uint8');
            write(S,ip);
            write(S,port,'uint32');

            disp("done");


        case 1 % key upload

            p=LavaLampToPrime1();
            q=LavaLampToPrime1();
 
            [n,e,d]=RSA_key_gen(p,q);
            write(S,[n,e],"int32");
            n=double(n);
            e=double(e);
            d=double(d);
            
            crip_key_length=read(S,1,"uint8");
            crip_serch_key=read(S,crip_key_length,"uint32");

            cript_port=read(S,1,"uint32");

            cript_ip_length=read(S,1,'uint8');
            cript_ip=read(S,cript_ip_length,'uint32');

            key=RSA_dec(crip_serch_key,d,n);
            key=char(key);

            ip=RSA_dec(cript_ip,d,n);
            ip=char(ip);

            port=RSA_dec(cript_port,d,n);

            add_key_to_main_DB(key,ip,port);

            disp('Key uploaded');
            write(S,1,'uint8');

    end
     
    
else
    disp('Client disconnected')
end


end