function prime=LavaLampToPrime4(a)
    
    lavalamp_number=5;
    power=16;
    %a=lavalamp();
    %a=im2gray(a);
    resp = a;
    
    sizes=size(resp);
    limit=sizes(2)/lavalamp_number;
    string_number="";
    
    
    for k=0:lavalamp_number-1
        
        max_counter=zeros(1,8);
        
        for i=1:sizes(1)
                for j=1:limit
                    pixel=resp(i,j+limit*k);
                    if pixel>150
                        n=get_number(j,i,limit,sizes(1));
                        max_counter(n)=max_counter(n)+1;
                    end
                end
        end

        n=max(max_counter);
        position=find(max_counter==n);
        position=position(end);
        string_number=append(string_number,int2str(position+1));
        n=8;
    end

    prod=str2num(string_number);
    prod=mod(prod,6542); %lavorando nel caso 2^16
    
    if prod<1000
        prod=prod+1000;
    end
    prod=uint16(prod);
    prime=nthprime(prod);
    



end

function n=get_number(x,y,x_limit,y_limit)
    if x<(x_limit/2) % sezione sinistra
        if y<(y_limit/4)
            n=1;
            return;
        elseif y<(y_limit/4)*2 
            n=3;
            return;
        elseif y<(y_limit/4)*3 
            n=5;
            return;
        else
            n=7;
            return;
        end
   
    else %sezione destra
        if y<(y_limit/4)
            n=2;
            return;
        elseif y<(y_limit/4)*2 
            n=4;
            return;
        elseif y<(y_limit/4)*3 
            n=6;
            return;
        else
            n=8;
            return;
        end
    end
    
end