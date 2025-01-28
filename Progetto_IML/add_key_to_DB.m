function add_key_to_DB(filename)
%loading util data
    load('DB.mat');
    load("key_limit.mat");
    load("main_server_port.mat");
    load("main_server_ip.mat");

    for i=1:length(DB)
        % If the filename is found in 'DB' do nothing
        if DB(i).filename==filename
            dips("the key already exists");
            return;
        end
    end
    % If the filename is not found in 'DB' add it to 'DB'
    key = matlab.net.base64encode(filename);
    limitWidth(key, key_limit);
    

    %% connection to the main DB
    connectionSuccessful = 0;
    while connectionSuccessful == 0    
        try
            C = tcpclient(main_server_ip, main_server_port);
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
    %% upload della chiave al server
    write(C,1,"int8");
    write(C,length(key),"int8");
    write(C,key,"string");
    done=read(C,"int8");
    if done==1 % if the key was uploaded correctly we can update our DB
        disp('Key uploaded');
        DB(end+1).filename=filename;
        DB(end).key=key;
        save('DB.mat','DB');
    else
        disp("upload fail");
    end

end

function s = limitWidth(s, n)
    s = extractBefore(s, min(n, s.strlength()) + 1);
end