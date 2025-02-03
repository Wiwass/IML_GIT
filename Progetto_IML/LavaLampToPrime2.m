function return_value=LavaLampToPrime2()

    cd assets\;
    if ~isempty(webcamlist)
        img=snapshot(webcam(1));
    else
        
        S = dir('*.jpg');
        k = randi([1,length(S)]);
        img=imread(S(k).name);
    end
    cd ..;


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

   int_length=11;
   temp=ones(1,int_length);
   position=1;
   for l=1:int_length-1
        j=randi(y,1);
        i=randi(x,1);
            temp(position) = mode(out(j,i,:));
            position=position+1;
        
   end
   temp=char(temp+'0');
   return_value=int32(nthprime(bin2dec(temp)));

end

