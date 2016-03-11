function  [newData] = GUIProcessing(data,newData,Duration,samplingRate)

m = numel(data(:,1)); % Length of the latest collection
length = numel(newData); % Length of the data that is suppposed to be on the screen

%%%% Zero padding the length before the data comes in, so that
%%%% the data appear to be moving from right to left
if(length < Duration*samplingRate)
    difference = Duration*samplingRate - length;
    pad = zeros(difference,1);
    newData = horzcat(pad', newData');
    newData = newData';
end

%%%% Adding the recorded data to new data on screen %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(m < Duration*samplingRate)
    newData = horzcat(newData', data');
    newData = newData';
end

newData(1:m,:) = [];


end