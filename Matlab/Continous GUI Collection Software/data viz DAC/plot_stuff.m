%plot stuff

close all
% load('Wan_80kHz_data.mat')
data = all_links;
data = data(1:end-2,:);%kludge to fix that whole interpolation thing.
clearvars -except data subj_ID
figurename = '80kHz test';
filename = '80kHz test';
SUB_IDX = 99;



%define variables
NUM_LINKS = 24;
OFFSET = 2;
% data(end,1)=120.0001;
[old_sample_rate, output,~] = resamp_to_fixed(data,60);

save(strcat(subj_ID,'_resamp'),'output')

h1 = figure(1);
hold on

h3 = figure(3);
hold on

for i=2:1:NUM_LINKS+1
    color_idx = mod(i,7);
    color_idx = de2bi(color_idx,3);

    %resampled
    link = (output(:,i));
    %     link = (output(:,i)*3).^3;
    idx = 0:length(link)-1;
    idx = idx*.01667;

    figure(1);
    plot(idx,link-mean(link)+OFFSET*(i-1),'color',color_idx);

    %resampled lowpass
    %raw

    figure(3);
    plot(data(:,i)+OFFSET*(i-1),'color',color_idx)


end


figure(1)
title('resample data')
hgsave(h1,strcat(subj_ID,'_resamp'))

figure(3)
title('raw')
hgsave(h3,strcat(subj_ID,'_raw'))
