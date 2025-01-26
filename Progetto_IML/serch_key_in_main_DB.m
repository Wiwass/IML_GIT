function [id,ip,port] = serch_key_in_main_DB(key_in_main_DB)
    load('main_server_DB.mat');
    for i=1:length(main_server_DB)
        if main_server_DB(i).key==key_in_main_DB
            id=main_server_DB(i).key;
            ip=main_server_DB(i).ip;
            port=main_server_DB(i).server_port;
            return;
        end
    end
    id='nf';
    ip=0;
    port=0;
end