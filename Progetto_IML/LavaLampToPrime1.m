function prime=LavaLampToPrime1()
    lavalamp_number=5;
    power=11;
    a = lavalamp();
    a=im2gray(a);
    lap = [1 1 1; 1 -8 1; 1 1 1];
    resp = uint8(filter2(lap, a, 'same'));
    
    sizes=size(resp);
    limit=sizes(2)/lavalamp_number;
    prod=1;
    
    
    for k=0:lavalamp_number-1
        sum=1;
        for i=1:sizes(1)
                for j=1:limit
                    if resp(i,j+limit*k)>200
                        sum=sum+1;
                    end
                end
        end
        prod=prod*sum;
    end
    
    prod=int16(mod(prod,2^power));
    if prod<2^(power-1)
        prod=prod+2^(power-1);
    end
    prime=nthprime(prod);

end