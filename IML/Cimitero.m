function Output=FT(img)
    img_size=size(img);
    Output=zeros(img_size);
    Output=complex(Output);
    %for k=1:1:img_size(0)
    %for l=1:1:img_size()
    for i=1:1:img_size(1)
        for j=1:1:img_size(0)
            Output(i,j)=img(i,j)*exp(-2*1i*pi*((k*i)/img_size(0)+(l*j)/img_size(1)));
        end
    end
end

function Output=RFT(FT)
    img_size=size(FT);
    Output=zeros(img_size);
    Output=complex(Output);
    for i=1:1:img_size(1)
        for j=1:1:img_size(0)
            Output(i,j)=(FT(i,j)*exp(2*1i*pi*((k*i)/img_size(0)+(l*j)/img_size(1))))/(img_size(0)*img_size(1));
        end
    end


end