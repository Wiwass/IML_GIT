function prime=LavaLampToPrime3(a)
    
    lavalamp_number=5;
    power=16;
    %a=lavalamp();
    %a=im2gray(a);
    %lap = [1 1 1; 1 -8 1; 1 1 1];
    %resp = uint8(filter2(lap, a, 'same'));
    
    resp=a;

    sizes=size(resp);
    limit=sizes(2)/lavalamp_number;
    prod=1;
    
    
    for k=0:lavalamp_number-1
        x_sum=1;
        y_sum=1;
        counter=1;
        for i=1:sizes(1)
                for j=1:limit
                    if resp(i,j+limit*k)>150
                        x_sum=x_sum+j;
                        y_sum=y_sum+i;  % calcolo il braicentro dell'entropia della lavalamp;
                        counter=counter+1;
                    end
                end
        end
        median_prod=(x_sum+y_sum)/counter;
        prod=prod*median_prod;
    end
    
    prod=mod(prod,6542); %lavorando nel caso 2^16

    if isnan(prod)
        prod=1000;
    end

    if prod<1000 || prod==0 || prod==inf 
        prod=prod+1000;
    end
    prod=uint16(prod);
    prime=nthprime(prod);
end

