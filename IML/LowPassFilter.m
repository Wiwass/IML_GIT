function Output=LowPassFilter(y,x,d)
    Output=zeros(x,y);
    median_x=floor(x/2);
    median_y=floor(y/2);
    for i=1:1:y
        for j=1:1:x
            temp=sqrt((median_y-i)*(median_y-i)+(median_x-j)*(median_x-j));
                if(temp<d)
                    Output(i,j)=1;
                end
        end

    end
end



