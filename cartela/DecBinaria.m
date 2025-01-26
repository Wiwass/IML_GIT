function out=DecBinaria(img)
   vec=size(img);
   y=vec(1);
   x=vec(2);
   out=zeros(y,x,8);
   for i=1:1:x
        for j=1:1:y
            for k=1:1:8
            supporto = dec2bin(img(j,i),8)=='1';
            out(j,i,:) = supporto;
            end
            
        end
   end

   for k=1:1:8
        temp=zeros(y,x);
        figure
        for i=1:1:x
        for j=1:1:y
            temp(j,i) = out(j,i,k);
        end
        end
        imshow(temp);
   end


end

