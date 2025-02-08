clear unique_data;
close all;
clear freq1;
unique_data=unique(array1);
for i=1:length(unique_data)
    indices=find(array1==unique_data(i));
    freq1(i)=length(indices);
end
bar(unique_data,freq1);
median1=mean(freq1);

clear unique_data;
clear freq3;
unique_data=unique(array3);
for i=1:length(unique_data)
    indices=find(array3==unique_data(i));
    freq3(i)=length(indices);
end
figure
bar(unique_data,freq3);
median3=mean(freq3);


clear unique_data;
clear freq4;
unique_data=unique(array4);
for i=1:length(unique_data)
    indices=find(array4==unique_data(i));
    freq4(i)=length(indices);
end
figure
bar(unique_data,freq4);
median4=mean(freq4);

