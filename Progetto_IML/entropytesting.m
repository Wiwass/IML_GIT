clear all

tic
while 1
cam=webcam(1);
img=snapshot(cam);
pause(1);
img2=snapshot(cam);

difference=img-img2;
imshow(difference);
   
if toc>60
    break;
end

end

close all;