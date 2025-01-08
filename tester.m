clear all;

x=imread("transform.jpg");
X=fft2(x);

p=997;
q=809;

temp=fft_criptation(X,4,p,q);
result=fft_decriptation(temp,4,p,q);

result=ifft2(result);

if(mean(mean(mean(result)))==mean(mean(mean(x))))
    print("ok");
end
%imshow(result);