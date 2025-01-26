function add_key_to_main_DB(key,ip,server_port)
    load('main_server_DB.mat');
    for i=1:length(main_server_DB)
        % If 'key' is found in 'main_server_DB'
        if main_server_DB(i).key==key
            % Update 'main_server_DB'
            main_server_DB(i).ip=ip;
            main_server_DB(i).server_port=server_port;
            save('main_server_DB.mat','main_server_DB');
            return;
        end
    end
    % If 'key' is not found in 'main_server_DB'
    main_server_DB(end+1).key=key;
    main_server_DB(end).ip=ip;
    main_server_DB(end).server_port=server_port;
    save('main_server_DB.mat','main_server_DB');
end