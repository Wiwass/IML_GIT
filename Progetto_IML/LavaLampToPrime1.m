function prime=LavaLampToPrime1()

    lavalamp_number=5;
    a=lavalamp();
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
                    if resp(i,j+limit*k)>150
                        sum=sum+1;
                    end
                end
        end
        prod=prod*sum;
    end
    
    prod=mod(prod,6542); %lavorando nel caso 2^16
    if prod<1000
        prod=prod+1000;
    end
    prod=uint16(prod);
    prime=nthprime(prod);

end