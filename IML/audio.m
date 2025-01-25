clear all;
close all;
load stereo_sample.mat


filename = 'stereo_sample.wav';
audiowrite(filename,y,Fs);





%% splitting reverse e echo


[y,Fs] = audioread(filename);
sizes=size(y);
length=sizes(1);

audiowrite(filename,y,Fs);

left=zeros(1,length);  %channel splitting
right=zeros(1,length);

reverse=zeros(sizes);  %reverse

echo=zeros(sizes);  %echo
delay=1000;

for i=1:1:(sizes(1))
    left(i)=y(i,1);
    right(i)=y(i,2);
    reverse(i)=y(length-i+1);
    if i+delay<length
        echo(i+delay)=y(i)*0.8;
    end
end

figure
bar(left);

figure 
bar(right);

echo=echo+y;

no_voices=right-left;


%% filtraggio
f=Fs;

%% basso

fNorm = 200 / (f/2);   
[b,a] = butter(10, fNorm, 'low');  %filtro passa basso
AudioLow = filtfilt(b, a, y);

figure

freqz(b,a,128,f);

%% alto

fNorm = 3000 / (f/2);
[b, a] = butter(10, fNorm, 'high');  %%filtro passa alto
AudioHigh = filtfilt(b, a, y);

figure

freqz(b,a,128,f);

%% banda

fNorm = [500/(f/2), 2500/(f/2)];
[b, a] = butter(10, fNorm, 'stop');  %filtro passa banda
AudioBand = filtfilt(b, a, y);


figure

freqz(b,a,128,f);