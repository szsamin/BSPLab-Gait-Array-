function DataSavePrompt(timeData,saveData,samplingRate,Duration)

str3 = sprintf('datafile_%s.mat',datestr(now,'yyyymmddTHHMMSS'));
[file,path] = uiputfile(str3,'Save Workspace As');
saveData; timeData; samplingRate; Duration;
save(fullfile(path, file),'timeData','saveData','samplingRate','Duration');

end