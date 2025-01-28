function img=lavalamp()
    cd assets\;
    S = dir('*.jpg');
    k = randi([1,length(S)]);
    img=imread(S(k).name);
    cd ..;
end