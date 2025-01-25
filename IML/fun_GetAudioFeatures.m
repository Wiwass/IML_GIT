function F=fun_GetAudioFeatures(chunk,Nfeatures)
   echo off;
    
   ordered_chunk=sort(chunk,2,'descend');
   chunk_size=size(chunk);
   F=zeros(chunk_size(1),Nfeatures+1);
   k=1;
   
   for y=1:1:chunk_size(1)
       ssq=0;
       k=1;
       for x=1:1:chunk_size(2)
           ssq=chunk(y,x)*chunk(y,x)+ssq;

           temp=find(ordered_chunk(y,:)==chunk(y,x),1,'first');

           if temp<Nfeatures+1 && k<Nfeatures+1
              k=k+1;
              F(y,k)=x;
              ordered_chunk(y,temp)=0;
           end
           
       end
       F(y,1)=ssq;
   end
    
end
