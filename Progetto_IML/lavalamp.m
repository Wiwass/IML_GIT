function img=lavalamp()
    cd assets\;
    if ~isempty(webcamlist)
        cam=webcam(1);
        img=snapshot(cam);
        pause(0.2);
        img2=snapshot(cam);
        img=img-img2;
    else
        S = dir('*.jpg');
        k = randi([1,length(S)]);
        img=imread(S(k).name);
    end
    cd ..;

end