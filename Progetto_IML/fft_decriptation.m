function output=fft_decriptation(cripted_img,scale,p,q)
    img_size=size(cripted_img);
    temp=zeros(img_size(1)/scale,img_size(2)/scale);
    target=zeros(img_size(1),img_size(2));

    for x=1:1:img_size(1)/scale
        for y=1:1:img_size(2)/scale
            vector=generate_coordinates(x,y,p,q,target);
            target(vector(1),vector(2))=1;
            temp(x,y)=cripted_img(vector(1),vector(2));

        end
    end

    for x=1:1:img_size(1)
        for y=1:1:img_size(2)
            if target(x,y)==0
                vector(1)=int32(mod(x*p,img_size(1)/scale));
                vector(2)=int32(mod(y*q,img_size(2)/scale));

                if(vector(1)==0)
                    vector(1)=vector(1)+1;
                end
                if(vector(2)==0)
                   vector(2)=vector(2)+1;
                end

                target(x,y)=target(x,y)+1;
                temp(vector(1),vector(2),target(x,y))=cripted_img(x,y);
            end
        end
    end

    output=zeros(img_size(1)/4,img_size(2)/4);
    for x=1:1:img_size(1)/4
        for y=1:1:img_size(2)/4
            output(x,y)=mode(temp(x,y,:));
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