function add_key_to_DB(filename)
%loading util data
    load('DB.mat');
    load("key_limit.mat");
    load("main_server_port.mat");
    load("main_server_ip.mat");
    load("second_server_ip.mat");
    load("second_server_port.mat");

    for i=1:length(DB)
        % If the filename is found in 'DB' do nothing
        if DB(i).filename==filename
            disp("the key already exists");
            return;
        end
    end
    % If the filename is not found in 'DB' add it to 'DB'
    key =char(matlab.net.base64encode(filename));
    if(length(key)>key_limit)
        key = key(1:50);
    end

    %% connection to the main server
    connectionSuccessful = 0;
    while connectionSuccessful == 0    
        try
            C = tcpclient(main_server_ip, main_server_port,"Timeout",60);
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
    %% upload of the key to the main server

    write(C,1,'uint8'); % key upload request

    pk=read(C,2,'int32'); %RSA_pk
    n=double(pk(1));
    e=double(pk(2));
    
    crip_key=RSA_enc(char(key),n,e);
    crip_port=RSA_enc(second_server_port,n,e);
    crip_ip=RSA_enc(char(second_server_ip),n,e);
    
    write(C,length(crip_key),"int8");
    write(C,int32(double(crip_key)),"uint32"); %sending the cripted_key to the server

    write(C,crip_port,"uint32");

    write(C,length(crip_ip),"uint8");
    write(C,uint32(double(crip_ip)),"uint32");

    done=read(C,1,"uint8");
    if done==1 % if the key was uploaded correctly we can update our DB
        disp('Key uploaded');
        DB(end+1).filename=filename;
        DB(end).key=key;
        save('DB.mat','DB');
    else
        disp("upload fail");
    end

end
