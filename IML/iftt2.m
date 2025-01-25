clear all;


x=imread("lena.jpg");
x=rgb2gray(x);
X=fft2(x);
y=ifft2(X);


figure
imshow(x);

figure
imshow(y,[]);