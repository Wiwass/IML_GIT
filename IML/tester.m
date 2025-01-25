clear all;

x=imread("transform.jpg");

layer_1=fft2(x(:,:,1));
layer_2=fft2(x(:,:,2));
layer_3=fft2(x(:,:,3));

X(:,:,1)=layer_1;
X(:,:,2)=layer_2;
X(:,:,3)=layer_3;

p=997;
q=809;

temp=fft_criptation(X,4,p,q);
result=fft_decriptation(temp,4,p,q);


layer_1=ifft2(result(:,:,1));
layer_2=ifft2(result(:,:,2));
layer_3=ifft2(result(:,:,3));

result(:,:,1)=layer_1;
result(:,:,2)=layer_2;
result(:,:,3)=layer_3;


imshow(result,[]);