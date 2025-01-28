clear all;
close all;


x=imread("assets\immages\Screenshot 2023-07-27 102031.png");

x=im2gray(x);

x=im2gray(x);

imshow(x);

X=fft2(x);

%p=int32(404221);
%q=int32(692161);
%scale=uint32(4);

%temp=fft_criptation(X,scale,p,q);
%result=fft_decriptation(temp,scale,p,q);
%result=X;
%if X==result
%    disp("ok");
%end

output=ifft2(X);
output=uint8(output);

figure
imshow(output);