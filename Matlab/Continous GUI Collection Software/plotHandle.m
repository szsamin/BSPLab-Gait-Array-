function [a, b, c] = plotHandle(newData, Duration,samplingRate, inputRange)

% Initialize the plot interface on the Figure
timespan = linspace(1,Duration,Duration*samplingRate);
positionVector1 = [0.1, 0.08, 0.8, 0.8];    % position of first subplot
subplot('Position',positionVector1);
a = plot(timespan,newData(:,1),'r-');
hold on; b = plot(timespan,newData(:,2),'b-');
c = plot(timespan,newData(:,3),'k-');

ylim(inputRange);
xlabel('Time(sec)'); ylabel('Ouput(V)'); str = sprintf('Sampling at %s',num2str(samplingRate)); legend('MUX 1','MUX 2','LSB');
title(str); hold off;

end