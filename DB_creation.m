function Create_Db(path,wsize,step,Nfeatures)
    

    S = dir('*.mp3');
    for k = 1:length(S)
        
        filename = S(k).name;
        track=audioread(filename);
        
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        sample=fun_GetAudioFeatures(fun_windowing(y,wsize,step),Nfeatures);
        s=struct('name',filename,'sample',sample);
        DB(end+1)=s;
        
        clear(filename);
        
    end
    output=struct('wsize',wsize,'step',step,'Nfeatures',Nfeatures,'DB',DB);
    save("DB.mat",output);
end