%pre raw data for downsampling and plotting

idx = and((dat_temp>.5),(dat_temp<4.5));
dat_temp(dat_temp<.5)=0;
dat_temp(dat_temp>4.5)=1;
dat_temp(idx) = NaN;
dat_nan = sum(dat_temp')';
nan_logical = not(isnan(dat_nan));

sig_log = signal(nan_logical,:);
dat_log = dat_temp(nan_logical,:);
time_log = time(nan_logical,:);

clear dat_temp signal dat_nan nan_logical

idx = bi2de(dat_log);
% plot(idx,'*')

idx_diff = [0; diff(idx)];
idx_diff(not(idx_diff==0))=1;
c_sum = cumsum(idx_diff);

c_sum_2 = c_sum(not(idx_diff));
sig_log_2 = sig_log(not(idx_diff),:);
idx_2 = idx(not(idx_diff));
time_log_2 = time_log(not(idx_diff));
DI2 = abs(diff(idx_2));
DI2(DI2>1)=1;

clear idx sig_log dat_log time_log idx_diff c_sum

mx_c_sum = max(c_sum_2);
SI = [sig_log_2,idx_2,time_log_2];

clear sig_log_2 idx_2 time_log_2

%find the average value of the signal held between each MUX switch.
sig_fin = zeros(length(DI2),4);
% sig_fin_all_data_1 = zeros(length(DI2),7);
counter = 1;
for i = 1:length(DI2)
    if(DI2(i)==1)
        if(i+FREQ_MOD>length(DI2))
            idx_temp = length(DI2);
        else
            idx_temp = i+FREQ_MOD;
        end
        final_window_width = SI(i+OFFSET:idx_temp,:);
        
        %This version is designed to filter the results of the window to be
        %sure you only get a specific link
        %         temp_link_id = mode(temptemp(:,end-1));
        %         temp_link_log = temptemp(:,end-1)==temp_link_id;
        %         temp_link = temptemp(temp_link_log,end-1);
        %         temp_link = temp_link(1);
        %         temp_sig = mean(temptemp(temp_link_log,1:2)); %or switch for sum
        %         temp_time = mean(temptemp(temp_link_log,end));%switch for sum
        
        %This version is designed to work when you KNOW FOR SURE that you are only
        %getting as single link's worth of data.
        temp_link = final_window_width(1,end-1);
                temp_sig = sum(final_window_width(:,1:2));
        temp_time = sum(final_window_width(:,end));
        
        
%         temp_sig_1 = temptemp(:,1);%temporary: for seeing all data
        %         temp_sig_2 = temptemp(:,2);%temporary: for seeing all data
        %         temp_link = temptemp(:,end-1);
        %         temp_time = temptemp(:,end);
        
        %         if(length(temp_link)>1)%noise in the final signal is causing me to wonder if i am miss-aligning these somehow.
        %             %this should check to see that none of the value are from a different link.
        %             display('Something is wrong: not all of these data points are from the same link!')
        %         end
        try
            sig_fin(counter,:) = [temp_sig temp_link temp_time];
%             sig_fin_all_data_1(counter,:) = [temp_sig_1' temp_link temp_time];
            %             sig_fin_all_data_2(counter,:) = [temp_sig_2' temp_link temp_time];
        catch
            display('error: could not concatonate. disregard if this is the final step')
        end
        counter = counter+1;
    end
    
    if(mod(i,1000)==0)
        display(num2str(i));
    end
end
% pre_mean_data = sig_fin_all_data_1;
% temp = logical(sum(pre_mean_data')');
% pre_mean_data = pre_mean_data(temp,:);
% save('Erich_not_avgd','pre_mean_data')

sig_fin(:,1) = sig_fin(:,1)/(FREQ_MOD-OFFSET+1);
sig_fin(:,2) = sig_fin(:,2)/(FREQ_MOD-OFFSET+1);
sig_fin(:,end) = sig_fin(:,end)/(FREQ_MOD-OFFSET+1);


clear SI DI2

%now we make the matrix look the way that we want it to.
isgood = logical(sum(sig_fin')');
sig_fin = sig_fin(isgood,:);
link_idx = unique(sig_fin(:,3));

cycle1 = min(find(sig_fin(:,3)==0));
sig_fin = sig_fin(cycle1:end,:);
num_row = floor(length(sig_fin)/16);
num_col = length(link_idx)*2+1;

temp_mat = zeros(num_row,num_col);
counter = 1;
for i=1:16:length(sig_fin)
    timestamp = mean(sig_fin(i:min(i+15,length(sig_fin)),end));
    temp_mat(counter,1) = timestamp;
    for j=0:15
        try
            temp_val = sig_fin(i+j,1:2);
            temp_mat(counter,j+2) = temp_val(2);
            temp_mat(counter,j+18) = temp_val(1);
        catch
            display('end loop')
        end
    end
    counter = counter+1;
end
all_links = temp_mat(:,[1:13,18:29]);
save(strcat(subj_ID,'_HS_test.mat'),'all_links','single_sensor_9')
