function Output=Conv_filter(filter,img)
img_size=size(img);
filter=filter*(-1);
down=img_size(1);
right=img_size(2);
sizes=(size(filter));
filter_size=sizes(1);
Output=zeros(img_size);
filter_content_sum=0;

for i=1:1:filter_size
    for j=1:1:filter_size
        filter_content_sum=filter_content_sum+filter(i,j);
    end
end

    for i=1:1:down
        for j=1:1:right
            Output(i,j,:)=pixel_conv(filter,img,down,right,filter_size,filter_content_sum,j,i);
        end
    end
    
end

function pixel=pixel_conv(f,img,size_y,size_x,filter_size,filter_content_sum,x,y)


sum=zeros(1,1,3);
    for i=-(floor(filter_size/2)):1:(floor(filter_size/2))
        index1=y+i;

        for j=-(floor(filter_size/2)):1:(floor(filter_size/2))
            index2=x+j;

            if(index1>size_y||index1<1||index2<1||index2>size_x)
           
            else
                a=i+floor(filter_size/2)+1;
                b=j+floor(filter_size/2)+1;
                cose=img(index1,index2,:);
                sum=sum+f(a,b)*double(cose);
          
            end

        end
        
    end
    pixel=sum/filter_content_sum;
end
