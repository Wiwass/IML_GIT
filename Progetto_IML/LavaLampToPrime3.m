function prime=LavaLampToPrime3()
    
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
        x_sum=1;
        y_sum=1;
        counter=0;
        for i=1:sizes(1)
                for j=1:limit
                    if resp(i,j+limit*k)>200
                        x_sum=x_sum+j;
                        y_sum=y_sum+i;  % calcolo il braicentro dell'entropia della lavalamp;
                        counter=counter+1;
                    end
                end
        end
        median_prod=(x_sum+y_sum)/counter;
        prod=prod*median_prod;
    end
    
    prod=int16(mod(prod,2^power));
    if prod<2^(power-1)
        prod=prod+2^(power-1);
    end
    prime=nthprime(prod);


end