
while true
oxygen = urlread('https://health-monitoring-system-0623-default-rtdb.firebaseio.com/123/oxygen.json');
temp = urlread('https://health-monitoring-system-0623-default-rtdb.firebaseio.com/123/temperature.json');
heart = urlread('https://health-monitoring-system-0623-default-rtdb.firebaseio.com/123/heart_rate.json');
Temp = str2num(erase(temp,'"'));
Oxygen = str2num(erase(oxygen,'"'));
Heart = str2num(erase(heart,'"'));
%fuzzy
pred = evalfis([Oxygen,Temp,Heart], Fuzzy_FYP_Project);
pred = num2str(pred);
prediction = ['https://api.thingspeak.com/update?api_key=JXZ7DXCBWA16D052&field1=',pred];
urlread(prediction);
prediction;
k=0;
while k==30
    k=k+1;
end
end