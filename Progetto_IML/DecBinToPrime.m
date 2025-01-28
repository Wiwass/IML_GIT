function return_value=DecBinToPrime(img)
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

   int_length=32;
   temp=ones(int_length);
   position=1;
   for l=2:1:int_length
        j=randi(y,1);
        i=randi(x,1);
            temp(position) = mean(out(j,i,:));
            position=position+1;
        
   end

   return_value=int32(nthprime(bin2dec(temp)));

end

