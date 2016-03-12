% Real Time Visualization for the DAQ IR Gait System - BSP Lab Summer 2015
% Author - Shadman Zaman Samin
% The visualizer is compatible to MCC DAQ with a legacy based system. The
% function prompts the user to select a sampling rate. The GUI is then
% generated, where the user is asked to start the collection using the START
% button. The CLEAR button closes the figure and prompts the user to save
% the file in a designated location.
% --------------------- Hardware Set up ---------------------------------
% Below, is the detail layout of the hardware connections with the IR GAIT
% system
% Analog Pin Connections ------------------------------------------------
% Pin 1 (CH0 H)	----> MUX 1
% Pin 2 (CH1 H) ----> MUX 2
% Pin 3 (CH2 H) ----> Counter Bit 0 [LSB]
% Pin 4 (CH3 H) ----> Counter Bit 1
% Pin 5 (CH4 H) ----> Counter Bit 2
% Pin 6 (CH5 H) ----> Counter Bit 3 [MSB]
%
% Once all the analog pins are connected. Connect all the corresponding (CHX L) to (AGND).
% Also connect the GND with the IR Gait system with GND. Connect the (+5
% ext) with the power source output.
%
% ----------------------- GUI Layout -----------------------------------
% The GUI has few different components. The GUI has a sliding windows of 3
% seconds. The toolbar allows the user to make changes in the plot in real
% time. The buttons on the user interface is as follows.
% PLAY button starts the collection.
% CLEAR button ends collection and prompts the users to save the data.
% MUX 1 button clear/plots the signals from MUX 1
% MUX 2 button clear/plots the signal from MUX 2
% LSB button clears/plots the signal from LSB Counter Bit

function main_gaitContinous
global saveData; global timeData; global clear1; global button1; global button2; global button3; global toggle;
timer = 0; N = 6; % Timer for the real time clock, and N+1 <-- number of analog points


[samplingRate] = samplingRatePrompt;

%%% Finds a DAQ, if its already running stop it.
if (~isempty(daqfind))
    stop(daqfind)
end

%%%%%%%%%%%% GUI SET UP %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Setting up the Graphical user Interface %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f = figure('Visible','on','Position',[200,50,1024,600],'name','DAQ Visualizer');
set(f,'toolbar','figure');

%%% Time Elapsed GUI
time_elapsed = uicontrol('Style','text',...
    'Position',[20 200 50 20],...
    'String','Value');

% Clear button GUI to end the program and save the data
clearButton = uicontrol('Style','pushbutton','String','Close',...
    'Position',[20 50 50 20],...
    'Callback',@setClear);

    function setClear(source,~)
        clear1 = get(source,'Value');
    end

% Toggle button to play/start recording
toggleButton1 = uicontrol('Style','togglebutton','String','MUX 1',...
    'Position',[20 70 50 20],...
    'Callback',@Button1);

    function Button1(source,~)
        button1 = get(source,'Value');
    end

% Toggle button to play/start recording
toggleButton2 = uicontrol('Style','togglebutton','String','MUX 2',...
    'Position',[20 90 50 20],...
    'Callback',@Button2);

    function Button2(source,~)
        button2 = get(source,'Value');
    end

% Toggle button to play/start recording
toggleButton3 = uicontrol('Style','togglebutton','String','LSB',...
    'Position',[20 110 50 20],...
    'Callback',@Button3);

    function Button3(source,~)
        button3 = get(source,'Value');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%% Setting up the input Parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%
Duration = 3; %% Duration in seconds
% numberOfSample0s = samplingRate; %% Total number of samples that needs to be collected
inputRange = [-5 5]; %% Define the input range for the input Voltage +- 5 V
newData = zeros(Duration*samplingRate,N+1); % Creating a predefined array for the plotdata == newData
[ai] = DAQInitialize(N,samplingRate,1000*samplingRate,inputRange); % Function to initialize all the DAQ Hardware parameters and create the hardware object
[a, b, c] = plotHandle(newData, Duration,samplingRate, inputRange); % Plot handles to create the figure and plot routine

% Toggle button to play press button to start recording
toggleButton = uicontrol('Style','togglebutton','String','Play',...
    'Position',[20 20 50 20],...
    'Callback',@toggle1);

    function toggle1(source,~)
        toggle = get(source,'Value');
        % When play button is hit
        while(toggle== 1 && isempty(toggle) ~= 1)
            start(ai); % Start recording
            while(isrunning(ai)) % If the object is running
                
                while(ai.SamplesAvailable <=0) %% Allow enough time to collect data
                end
                
                [data,~,~] = getdata(ai,ai.SamplesAvailable); %% Push the buffer data into the array
                
                tic; % Tic counter to track the length of the time
                
%                 saveData = horzcat(saveData,data'); % save all the data in an array
%                 timeData = horzcat(timeData,time'); % save the time in an array
                
                [newData] = GUIProcessing(data,newData,Duration,samplingRate); % Data processing to create a X second sliding window
                handleValueSet(a,b,c,newData,Duration,samplingRate,button1,button2,button3); % Handle set to plot the values on the figure
                drawnow;
                
                timer = timer + toc;
                set(time_elapsed,'String',timer);
                
                if(clear1 == 1)
                    DAQclear(ai);
%                     DataSavePrompt(timeData,saveData,samplingRate,max(time));
                    guiClear;
                    break;
                end
                
            end
            guiClear;
            break;
        end
    end
end
