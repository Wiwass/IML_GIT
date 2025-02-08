clear all

tic

cam=webcam(1);
figure;
preview(cam);
figure;
while 1

img=snapshot(cam);
pause(1);
img2=snapshot(cam);

difference=img-img2;
imshow(difference);
   
if toc>600000
    break;
end

end

close all;