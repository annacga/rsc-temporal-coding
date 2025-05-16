function rmse = plotDecodingTime(predTime, time, keepClose, maxval)

predTime = predPosTest;
time = realPosTest;
maxval = max(time)
x =1/31:1/31:length(time)/31;
x2 =1/31:1/31:length(predTime)/31;
figure()
ax1 = subplot(2,1,1); 
plot(x(1:1500),time(1:1500),'LineWidth', 1.5)
hold on 
plot(x2(1:1500),predTime(1:1500), 'LineWidth', 1.5)
legend('real position','predicted position');
xlim([x(1) x(1500)])
            
xlim([1 length(predTime)])
xlabel('Time in [s]')
ylabel('Position in [cm]')
yticks([0 20 40 60 80])
yticklabels({'0','40','80','120','160'})
            
for i = 1:length(time)
    predError(i) = abs(time(i)-predTime(i));
    if predError(i) > maxval/2 && time(i) > predTime(i)
        predError(i) = abs(maxval-time(i)+predTime(i));
    elseif predError(i) > maxval/2 && time(i) < predTime(i)
        predError(i) = abs(maxval-predTime(i)+time(i));
    end
end
timeVals = unique(time);
for i = 1:length(timeVals)
    rmse(i) = mean(predError(time == timeVals(i)));
    idxNo(i) = length(find(time == timeVals(i)));
    rsmeStd(i) = std(predError(time == timeVals(i)));
end

% combos = unique(predError);
% for j = 6:max(idxNo(i))-1
%     %  vecRnd= [vecRnd; unique(predError)];
%     combos =  combvec(combos,combos);
% end
% randrmse2 = mean(combos(1:3,:))';
randrmse = mean(combos)';
randrmse3 = mean(Spill');

for i = 1:length(timeVals)
    
    pVal(i) = length(find(randrmse3 < rmse(i)))/length(randrmse3);
end

rmse = mean(predError);

ax2 = subplot(2,1,2);
plot(1:length(time),predError, 'LineWidth',1)

figure()
plot(rmse)
errorbar(rmse,rsmeStd)
set(gca,'FontSize', 15,  'FontName', 'Gotham')
xlabel('Class')
ylabel('RMSE')

figure()
plot(pVal, 'LineWidth', 1.5)
set(gca, 'FontSize',  15,  'FontName', 'Gotham')
line(1:40,ones(size(timeVals))*0.05, 'LineWidth', 1.5, 'LineStyle', '--')
xlabel('Class')
ylabel('p-Value')

Spill = importdata('/Users/annachristinagarvert/Downloads/multichoose-master/10.txt');
% xlim([1 length(predTime)])
% xlabel('Time(Samples)')
% ylabel('Error in [s]')
% yticks([0 1 2 3 4 5 6])
xlim([1 length(predTime)])
xlabel('Time(Samples)')
ylabel('Error in [cm]')
yticks([0 20 40 60 80])
yticklabels({'0','40','80','120','160'})

% yticks([0 10 20 30 40])
% yticklabels({'0','20','40','60','80'})

if strcmp(keepClose,'close') == 1
    close
end
    

figure()
plot( [0.81; 0.44], '.', 'MarkerSize', 35, 'Color', [0.6588    0.7882    0.8314])
hold on
plot( [0.98; 0.5], '.', 'MarkerSize', 35 , 'Color', [0.2863    0.4196    0.5569])
hold on
plot([0.89; 0.76 ],'.', 'MarkerSize', 35, 'Color', [198, 82, 77]./255)
hold on
plot([0.98; 0.76],'.', 'MarkerSize', 35 )%, 'Color', [215, 223,225]./255)
xticks([1 2])
ylabel('Fraction of Original ROI Number')
xticklabels({'After SNR', 'After Clustering'})
set(gca, 'FontName', 'Gotham', 'FontSize', 15)
xlim([0.5 2.5])
ylim([0.4, 1.05])

xticklabels({'m5051-20181012-01','m5051-20181014-01','m5051-20190524-01'})


