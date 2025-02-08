testing_sample=10000;
array1=zeros(1,testing_sample);
array2=zeros(1,testing_sample);
array3=zeros(1,testing_sample);
array4=zeros(1,testing_sample);

for i=1:1:testing_sample
    tic
    a=lavalamp();
    a=im2gray(a);
    array1(i)=LavaLampToPrime1(a);

    array3(i)=LavaLampToPrime3(a);
    array4(i)=LavaLampToPrime4(a);
    toc
end
save("array1.mat","array1");

save("array3.mat","array3");
save("array4.mat","array4");


