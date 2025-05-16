
function [fig_behavior_session,performance_segments,dvalue_paper] = behavior(sData)
k=0;
k = k+1;
fig_behavior_session = figure('units','normalized','outerposition',[0 0 1 1]);

totalTrials(1,:)= sData.imData.variables.hits;
totalTrials(2,:)= sData.imData.variables.misses;
totalTrials(3,:)= sData.imData.variables.CR;
totalTrials(4,:)= sData.imData.variables.FA;

%% Plot response type
subplot(2,3,k)
x= 1:length(totalTrials);
for kk=1:length(x)
    if totalTrials(1,kk)==0
        y(1,kk)=NaN;
    else
        y(1,kk)=2;
    end
end
scatter(x,y,'filled')
hold on
for kk=1:length(x)
    if totalTrials(2,kk)==0
        y(1,kk)=NaN;
    else
        y(1,kk)=1.5;
    end
end
scatter(x,y,'filled')
hold on
for kk=1:length(x)
    if totalTrials(3,kk)==0
        y(1,kk)=NaN;
    else
        y(1,kk)=1;
    end
end
scatter(x,y,'filled')
hold on
for kk=1:length(x)
    if totalTrials(4,kk)==0
        y(1,kk)=NaN;
    else
        y(1,kk)=0.5;
    end
end
scatter(x,y,'filled')
legend('hit', 'miss', 'CR', 'FA')
ylim([0 2.5])
xlim([1 length(x)])
ylabel('response type')
xlabel('trial')

% Plot performance
k=k+1;
subplot(2,3,k)
cc=0;
performance_segments = [];
%Sliding window
for p=1:length(sData.imData.variables.trialIndices)
    cc=cc+1;
    try
        performance_segments (1,cc)= ((sum(sData.imData.variables.hits(1,p:p+9))+sum(sData.imData.variables.CR(1,p:p+9)))/10)*100;
    catch
        performance_segments (1,cc)= ((sum(sData.imData.variables.hits(1,p:length(sData.imData.variables.trialIndices)))+sum(sData.imData.variables.CR(1,p:length(sData.imData.variables.trialIndices))))/(length(sData.imData.variables.trialIndices)-p))*100;
    end
end

lengthSegments =1:length(sData.imData.variables.trialIndices);
plot(lengthSegments,performance_segments,'Color', [0/255 126/255 135/255], 'linewidth', 2)
hold on
line([length(sData.imData.variables.trialIndices)-10 length(sData.imData.variables.trialIndices)-10],[0 100])
ylim([0 100])
xlim([1 length(lengthSegments)])
ylabel('performance %')
box off
% legend ('performance=(#hit+#CR)/#trials')

% Plot d'
k=k+1;
subplot(2,3,k)
cc=0;
for p=1:length(sData.imData.variables.trialIndices)
    cc=cc+1;
    try
        hitRate_segments (1,cc)=(sum(sData.imData.variables.hits(1,p:p+24)))/25;
    catch
        hitRate_segments (1,cc)=(sum(sData.imData.variables.hits(1,p:length(sData.imData.variables.trialIndices))))/25;
    end
    try
        CRRate_segments (1,cc)=(sum(sData.imData.variables.CR(1,p:p+24)))/25;
    catch
        CRRate_segments (1,cc)=(sum(sData.imData.variables.CR(1,p:length(sData.imData.variables.trialIndices))))/25;
    end
    try
        FARate_segments (1,cc)=(sum(sData.imData.variables.FA(1,p:p+24)))/25;
    catch
        FARate_segments (1,cc)=(sum(sData.imData.variables.FA(1,p:length(sData.imData.variables.trialIndices))))/25;
    end
end

hitRate_segments (hitRate_segments ==0)=0.5;
hitRate_segments (hitRate_segments ==1)=(24-0.5);
FARate_segments (FARate_segments ==0)=0.5;
FARate_segments (FARate_segments ==1)=(24-0.5);
dvalue_paper = [];
cc=0;
for cc = 1:length(sData.imData.variables.trialIndices)
    cc=cc+1;
    try
        dvalue_paper (1,cc) = mean(norminv(hitRate_segments (1,cc:cc+24),0,1)-norminv(FARate_segments (1,cc:cc+24),0,1));
    catch
        dvalue_paper (1,cc) = mean(norminv(hitRate_segments (1,cc:length(sData.imData.variables.trialIndices)),0,1)-norminv(FARate_segments (1,cc:length(sData.imData.variables.trialIndices)),0,1));
    end
end
lengthSegments=1:(length(sData.imData.variables.trialIndices)+1);
plot(lengthSegments,dvalue_paper,'Color', [243/255 197/255 43/255], 'linewidth', 2)
hold on
line([length(sData.imData.variables.trialIndices)-25 length(sData.imData.variables.trialIndices)-25],[0 2])
xlim([1 length(lengthSegments)])
ylim([0 2])
ylabel('dPrime')
legend('dPrime')

% Plot Licking Rate
k=k+1;
subplot(2,3,k)
for n = 1:length(sData.imData.variables.trialIndices) %%Lick count in each stage
    stage=sData.imData.variables.stage(1,sData.imData.variables.trials==n);
    odor1=find(sData.imData.variables.lick(1,sData.imData.variables.trials==n)&stage==4);
    odor2=find(sData.imData.variables.lick(1,sData.imData.variables.trials==n)&stage==6);
    delay=find(sData.imData.variables.lick(1,sData.imData.variables.trials==n)&stage==5);
    preResponse=find(sData.imData.variables.lick(1,sData.imData.variables.trials==n)&stage==7);
    responseWin=find(sData.imData.variables.lick(1,sData.imData.variables.trials==n)&stage==8);
    ITI=find(sData.imData.variables.lick(1,sData.imData.variables.trials==n)&stage==9);
    lickrate=zeros(1,length(stage));
    lickrate(1,odor1)=1;
    lickrate(1,odor2)=1;
    lickrate(1,delay)=1;
    lickrate(1,preResponse)=1;
    lickrate(1,responseWin)=1;
    lickrate(1,ITI)=1;
    lickRate{n,1}=lickrate;
end

maxLengthCell=max(cellfun('size',lickRate,2));  %finding the longest vector in the cell array
for i=1:length(lickRate)
    for j=cellfun('size',lickRate(i),2)+1:maxLengthCell
        lickRate{i}(j)=0;   %zeropad the elements in each cell array with a length shorter than the maxlength
    end
end
mergedLickRate=cell2mat(lickRate);
plot(mean(mergedLickRate),'Color', [180/255 176/255 173/255], 'linewidth', 1) %% Adjust here with correct position of the line!!!
hold on
lick_rate_first =mean(mergedLickRate((1:length(sData.imData.variables.trialIndices)/2),:));
plot(lick_rate_first,'Color', [198/255 44/255 58/255], 'linewidth', 0.5) %% Adjust here with correct position of the line!!!
hold on
lick_rate_second =mean(mergedLickRate((length(sData.imData.variables.trialIndices)/2):length(sData.imData.variables.trialIndices)/2,:));
plot(lick_rate_second,'Color', [60/255 85/255 123/255], 'linewidth', 0.5) %% Adjust here with correct position of the line!!!
ylabel('average spike count')

%% Plot lick response yes/no
k=k+1;
subplot(2,3,k)
for n = 1:length(sData.imData.variables.trialIndices) %%Lick count in each stage
    stage=sData.imData.variables.stage(1,sData.imData.variables.trial==n);
    odor1=find(sData.imData.variables.lick(1,sData.imData.variables.trial==n)&stage==4);
    odor2=find(sData.imData.variables.lick(1,sData.imData.variables.trial==n)&stage==6);
    delay=find(sData.imData.variables.lick(1,sData.imData.variables.trial==n)&stage==5);
    preResponse=find(sData.imData.variables.lick(1,sData.imData.variables.trial==n)&stage==7);
    responseWin=find(sData.imData.variables.lick(1,sData.imData.variables.trial==n)&stage==8);
    ITI=find(sData.imData.variables.lick(1,sData.imData.variables.trial==n)&stage==9);
    lickrate=zeros(1,length(stage));
    lickrate(1,odor1)=1;
    lickrate(1,odor2)=1;
    lickrate(1,delay)=1;
    lickrate(1,preResponse)=1;
    lickrate(1,responseWin)=1;
    lickrate(1,ITI)=1;
    lickRate{n,1}=lickrate;
    
    if numel(odor1)==0
        lickYesNo(1,n)=NaN;
    else
        lickYesNo(1,n)=2.5;
    end
    
    if numel(delay)==0
        lickYesNo(2,n)=NaN;
    else
        lickYesNo(2,n)=2.0;
    end
    
    if numel(odor2)==0
        lickYesNo(3,n)=NaN;
    else
        lickYesNo(3,n)=1.5;
    end
    
    responses=[preResponse, responseWin];
    if numel(responses)==0
        lickYesNo(4,n)=NaN;
    else
        lickYesNo(4,n)=1;
    end
    
    if numel(ITI)==0
        lickYesNo(5,n)=NaN;
    else
        lickYesNo(5,n)=0.5;
    end
end
scatter(1:length(sData.imData.variables.trialIndices),lickYesNo(1,:),'filled')
hold on
scatter(1:length(sData.imData.variables.trialIndices),lickYesNo(2,:),'filled')
hold on
scatter(1:length(sData.imData.variables.trialIndices),lickYesNo(3,:),'filled')
hold on
scatter(1:length(sData.imData.variables.trialIndices),lickYesNo(4,:),'filled')
hold on
scatter(1:length(sData.imData.variables.trialIndices),lickYesNo(5,:),'filled')
legend('lick odor1', 'lick delay', 'lick odor2', 'lick response', 'lick ITI')
xlabel('trial')
ylabel('response type')

end