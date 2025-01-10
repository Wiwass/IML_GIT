clear all;
tic

x=imread("lena.jpg");
X=fft2(x);

p=997;
q=809;

temp=fft_criptation(X,4,p,q);
result=fft_decriptation(temp,4,p,q);

result=ifft2(X);


if(x==result)
    disp("ok");
end
imshow(result);
toc