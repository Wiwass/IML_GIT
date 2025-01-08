clear all;
close all;
x=imread('underexposed.jpeg');

trans='log';

fig1=ImTrans(x,trans);
fig2=ImTrans(x,trans);


figure;
title('Figure 1');
imshow(fig1);

figure;
title('Histogram1');
h=imhist(fig1)/numel(fig1);
bar(h);

figure;
title('Figure 2');
imshow(fig2);

figure;
title('Histogram2')
h=imhist(fig2)/numel(fig2);
bar(h);
