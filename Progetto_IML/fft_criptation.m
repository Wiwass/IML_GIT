function output=fft_criptation(transform,scale,p,q)
    img_size=size(transform);
    output=zeros(img_size(1)*scale,img_size(2)*scale);
    target=zeros(img_size(1)*scale,img_size(2)*scale);
    
    for x=1:1:img_size(1)
        for y=1:1:img_size(2)
            vector=generate_coordinates(x,y,p,q,target);
            target(vector(1),vector(2))=1;
            output(vector(1),vector(2))=transform(x,y);

        end
    end
   
    for x=1:1:img_size(1)*scale
        for y=1:1:img_size(2)*scale
            if target(x,y)==0
                vector(1)=int32(mod(x*p,img_size(1)));
                vector(2)=int32(mod(y*q,img_size(2)));

                if(vector(1)==0)
                    vector(1)=vector(1)+1;
                end
                if(vector(2)==0)
                   vector(2)=vector(2)+1;
                end

                target(x,y)=target(x,y)+1;
                output(x,y)=transform(vector(1),vector(2));
                
            end
        end
    end

end


function vector=generate_coordinates(x,y,p,q,target)

    target_size=size(target);

    X=int32(mod(p*x,target_size(1)));
    Y=int32(mod(q*y,target_size(2)));

    if(X==0)
        X=X+1;
    end
    if(Y==0)
        Y=Y+1;
    end

    if(target(X,Y)==1)
        vector=generate_coordinates(x+1,y+1,p,q,target);
    else
    vector(1)=X;
    vector(2)=Y;
    end
end