clear all;
f=imread('lena.jpg');

sizee=size(f);

F=fft2(f);
S=abs(F);
%S=log(1+abs(S));
%imshow(S,[]);

Fc=fftshift(F);
%figure
imshow(abs(Fc),[]);

%S2=log(1+abs(Fc));
%figure
%imshow(S2,[]);

filter=fftshift(fft2(HighPassFilter(sizee(1),sizee(2),32)));
Ffiltered=Fc.*filter;

figure
imshow(ifft2(Ffiltered));

