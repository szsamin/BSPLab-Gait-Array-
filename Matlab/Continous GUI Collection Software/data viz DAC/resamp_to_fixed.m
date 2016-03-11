function [ OLD_FREQ, data_resample, NSR ] = resamp_to_fixed( data, TRUE_FREQ )
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here
data = data(1:end-2,:);%kludge to fix that whole interpolation thing.
NSR = 0:length(data(:,1));
OSR = data(:,1)-data(1,1);
if((OSR(2)-OSR(1))>1) %this deals with the two timestamps used by the different data collection software
    NSR = NSR*(1/TRUE_FREQ)*10^6;
    mean_OSR = mean(diff(OSR))/(10^6);
else
    NSR = NSR*(1/TRUE_FREQ);
    mean_OSR = mean(diff(OSR));
end
OSR_avg = linspace(0,max(OSR),length(OSR));
% OSR_diff = OSR_avg-OSR'; 
% hist(OSR_diff,50); 
OLD_FREQ = 1/mean_OSR;
NSR_bool = NSR<=max(OSR_avg);
NSR = NSR(NSR_bool);
data_resample(:,1) = NSR;
L_NSR = length(NSR);
% data_resample(:,1) = NSR/(10^6);
num_sensors = length(data(1,:));
[N,D] = rat((TRUE_FREQ/OLD_FREQ));
for k=2:num_sensors
    single_sensor = data(:,k);
%     temp_resample = interp1(OSR,single_sensor,NSR);
%     temp_resample = resample(single_sensor,  TRUE_FREQ, round(1/mean_OSR));

    SST = interp1(OSR,single_sensor,OSR_avg);
    
    temp_resample = resample(SST, N, D);

    
    data_resample(:,k) = temp_resample(1:L_NSR);
end

end

