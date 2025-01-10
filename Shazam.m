function Shazam(DB_name,song)
   
    load(DB_name);
    wsize=output.wsize;
    step=output.step;
    Nfeatures=output.Nfeatures;
    DB=output.DB;
    
    song_sample = fun_GetAudioFeatures(fun_windowing(x,wsize,step),Nfeatures);
    
    for i=1:1:size(DB)
       if song_sample==DB(i).sample
          disp("corrisponde a:"DB(i).name);
          break;
       end
        
    end
    
    disp("nessuna corrispondenza");
    
    
end