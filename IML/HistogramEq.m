clear all;
close all;
x=imread('underexposed.jpeg');

%%

figure;
imshow(x);

figure;
title('Histogrameq')
h=imhist(x)/numel(x);
bar(h);

%%

figure;
title('Qualied Immage');
h=histeq(x);
imshow(h);

figure;
title('Histogrameq')
k=imhist(h)/numel(h);
bar(k);