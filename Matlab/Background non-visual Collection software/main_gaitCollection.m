% Function to collection non-real time data using the DAQ
% gaitCollection(samplingRate,minutes);
% Sampling Rate to specify the required sampling rate for the DAQ
% minutes to specify the time in minutes for the entire collection

function main_gaitCollection(samplingRate,minutes)

% samplingRate = 250000;
% minutes = 0;

%%% Finds a DAQ, if its already running stop it.
if (~isempty(daqfind))
    stop(daqfind)
end


numberOfSamples = samplingRate.*minutes*60;
inputRange = [-5 5];
N = 6; % Number of channels-1

% The code below Samples data and takes of data acquisition
audioOut('Initializing');
pause(5);


[ai] = DAQInitialize(N,samplingRate,numberOfSamples,inputRange);
start(ai); % Start the object - Begin Collection
audioOut('Start Walkings'); % The audio strings sends intructions
% [data,time,abstime,events] = getdata(ai);
[data,time,~,~] = getdata(ai); % Pull in the data

% Deactivate Data acquisition board
audioOut('End Collection'); % Intruct to stop doing collection
DAQclear(ai);

Duration = max(time);

% generatePlot(time,data);
DataSavePrompt(time,data,samplingRate,Duration);

end