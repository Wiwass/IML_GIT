clear all;
close all;


x=imread("assets\immages\Screenshot 2023-07-27 102031.png");

x=im2gray(x);

[y_size,x_size]=size(x);
temp=zeros(size(x));
k=1;
z=uint8(zeros(1,y_size*x_size));
uint8(z);
for i=1:1:y_size
    for j=1:1:x_size
        z(k)=uint8(x(i,j));
        k=k+1;
    end
end
z=uint8(z);

k=1;
for i=1:1:y_size
    for j=1:1:x_size
        temp(i,j) = z(k);
        k=k+1;
    end
end
temp=uint8(temp);

if x==temp
    disp("ok");
end

imshow(temp);
figure 
imshow(x);

return;














x=im2gray(x);
imshow(x);

X=fft2(x);

p=int32(404221);
q=int32(692161);
scale=uint8(4);

temp=fft_criptation(X,scale,p,q);
result=fft_decriptation(temp,scale,p,q);

if X==result
    disp("ok");
end

output=ifft2(result);

figure
imshow(result,[]);