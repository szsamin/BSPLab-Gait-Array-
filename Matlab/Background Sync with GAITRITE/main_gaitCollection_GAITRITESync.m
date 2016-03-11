% Function to collection non-real time data using the DAQ
% gaitCollection(samplingRate,minutes);
% Sampling Rate to specify the required sampling rate for the DAQ
% minutes to specify the time in minutes for the entire collection

function main_gaitCollection_GAITRITESync

global clear1;
samplingRate = 64000;
% minutes = 0;

%%% Finds a DAQ, if its already running stop it.
if (~isempty(daqfind))
    stop(daqfind)
end

[USER] = UserSpecify;

%%%%%%%%%%%% GUI SET UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setting up the Graphical user Interface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = figure('Visible','on','Position',[200,50,400,200],'name','DAQ Visualizer');
set(f,'toolbar','figure');

% f = figure('Visible','on','Position',[200,50,1024,600],'name','DAQ Visualizer');
% set(f,'toolbar','figure');


% Clear button GUI to end the program and save the data
clearButton = uicontrol('Style','pushbutton','String','Close',...
    'Position',[20 90 100 50],...
    'Callback',@setClear);

    function setClear(source,~)
        clear1 = get(source,'Value');
    end

%%% User
user_spec = uicontrol('Style','text',...
    'Position',[250 50 120 40],...
    'String','Value',...
    'FontSize',15);

%%% Walk number
walk_num = uicontrol('Style','text',...
    'Position',[150 50 80 40],...
    'String','Value',...
    'FontSize',15);


numberOfSamples = samplingRate.*10;
inputRange = [-5 5];
N = 6; % Number of channels-1

% Toggle button to play press button to start recording
toggleButton = uicontrol('Style','togglebutton','String','Play',...
    'Position',[20 20 100 50],...
    'Callback',@toggle1);

count = 0;

% positionVector1 = [0.1, 0.08, 0.8, 0.8];    % position of first subplot

    function toggle1(source,~)
        toggle = get(source,'Value');
        % When play button is hit
        while(toggle == 1)
            audioOut('Initializing');
            [ai] = DAQInitialize(N,samplingRate,numberOfSamples,inputRange);
            start(ai); % Start the object - Begin Collection
            audioOut('Start Walking'); % The audio strings sends intructions
            count = count + 1;
            set(user_spec,'String',USER);
            set(walk_num,'String',count);
            
            % [data,time,abstime,events] = getdata(ai);
            [data,time,~,~] = getdata(ai); % Pull in the data
            saveData = data; timeData = time;
            
            % Deactivate Data acquisition board
            audioOut('End Collection'); % Intruct to stop doing collection
            DAQclear(ai);
            Duration = max(time);
            str3 = sprintf('datafile_%s_%s_%s.mat',datestr(now,'yyyymmddTHHMMSS'),num2str(count),USER);
            save(str3,'timeData','saveData','samplingRate','Duration');
            
            if( (count == 1) || (count == 30) || (count == 60) || (count == 90))
            % Take this part out if not needed
            % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            f = figure();
            MAIN_data_viz(str3); str2 = sprintf('Walk for %s - %s',USER, num2str(count)); title(str2); ylabel('Output Voltage - Mean shifted'); xlabel('Samples');
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            end
            
            
            audioOut('Waiting for button Press');
            clearvars -except samplingRate numberOfSamples inputRange N count USER user_spec walk_num
            toggle = 0;
        end
    end
end