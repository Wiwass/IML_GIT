function Shazam(DB_name,song)
   
    load(DB_name);
    wsize=output.wsize;
    step=output.step;
    Nfeatures=output.Nfeatures;
    DB=output.DB;

    [y,Fs]=audioread(song);
    y=y(:,1);
    
    song_sample = fun_GetAudioFeatures(fun_windowing(y,wsize,step),Nfeatures);
    
    sizes=size(DB);
    for i=1:1:sizes(2)
       temp=DB(i);
       if size(song_sample)==size(temp.sample)
          if song_sample==temp.sample
            disp("corrisponde a:"+temp.name);
            return;
          end
       end
        
    end
    
    disp("nessuna corrispondenza");
    
    
end