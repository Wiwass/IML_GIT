clear all;
x=imread('lena.jpg');
[m,n]=size(x);
whos x

x=NegImg(x,255);