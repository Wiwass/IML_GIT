clear all;
x=imread('underexposed.jpeg');

neg=ImTrans(x,'neg');
pot=ImTrans(x,'pot');
log=ImTrans(x,'log');
con=ImTrans(x,'con');

figure;
imshow(neg);
figure;
imshow(pot);
figure;
imshow(con);
figure;
imshow(log);