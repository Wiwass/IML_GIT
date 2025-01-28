function img=lavalamp()
    S = dir('*.jpg');
    k = randi([1,length(S)]);
    img=imread(S(k).name);
end