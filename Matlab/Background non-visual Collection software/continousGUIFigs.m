function [clear1, button1, button2, button3] = continousGUIFigs(f)


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


end