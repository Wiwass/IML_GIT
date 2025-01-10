function Create_DB(path,wsize,step,Nfeatures)
    

    S = dir('*.mp3');
    
    
    for k = 1:length(S)
        
        filename = S(k).name;
        [y,Fs]=audioread(filename);
        y=y(:,1);

        
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        window=fun_windowing(y,wsize,step);
        sample=fun_GetAudioFeatures(window,Nfeatures);
        s=struct('name',filename,'sample',sample);
        DB(k)=s;
        
        clear(filename);
        
    end
    output=struct('wsize',wsize,'step',step,'Nfeatures',Nfeatures,'DB',DB);
    save("DB");
end