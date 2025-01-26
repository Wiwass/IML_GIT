function add_key_to_DB(filename)
    load('DB.mat');
    for i=1:length(DB)
        % If the filename is found in 'DB' do nothing
        if DB(i).filename==filename
            return;
        end
    end
    % If the filename is not found in 'DB' add it to 'DB'
    key = matlab.net.base64encode(filename);
    limitWidth(key, 10);
    DB(end+1).filename=filename;
    DB(end).key=key;
    save('DB.mat','DB');
end

function s = limitWidth(s, n)
    s = extractBefore(s, min(n, s.strlength()) + 1);
end