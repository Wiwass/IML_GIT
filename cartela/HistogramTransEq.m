clear all;
close all;
x=imread('underexposed.jpeg');

trans='log';
transImg=ImTrans(x,trans);

%%

figure;
imshow(transImg);

figure;
title('Histogrameq')
h=imhist(transImg)/numel(transImg);
bar(h);

%%

figure;
title('Trans Immage');
h=histeq(transImg);
imshow(h);

figure;
title('Histogrameq')
k=imhist(h)/numel(h);
bar(k);