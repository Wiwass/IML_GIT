function w=fun_windowing(y,windowshape,step)
    w=zeros(1,windowshape);
    y=y';
    k=0;
    j=1;
    limit=size(y);
    limit=limit(2);
    while 1
        if j+windowshape-1>limit
            break;
        end

        k=k+1;
        for i=0:1:windowshape-1
            w(k,i+1)=y(j+i);     
        end
        j=j+step+windowshape;
    end


end