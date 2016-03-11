function handleValueSet(a,b,c,newData,Duration,samplingRate,button1,button2,button3)
if(button1 == 1)
    set(a,'YData',newData(:,1));
else
    set(a,'YData',zeros(Duration*samplingRate,1));
end
if(button2 == 1)
    set(b,'YData',newData(:,2));
else
    set(b,'YData',zeros(Duration*samplingRate,1));
end
if(button3 == 1)
    set(c,'YData',newData(:,3));
else
    set(c,'YData',zeros(Duration*samplingRate,1));
end

end