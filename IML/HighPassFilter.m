function Output=HighPassFilter(y,x,d)
    Output=ones(x,y);
    median_x=(x/2);
    median_y=(y/2);
    for i=1:1:y
        for j=1:1:x
            temp=sqrt((median_y-i)*(median_y-i)+(median_x-j)*(median_x-j));
                if(temp<d)
                    Output(i,j)=0;
                end
            

        end
    end

end