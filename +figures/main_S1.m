 
clear all
close all

sessions  = {'m118-20191001-01','m3069-20191001-01'};

 sData       = [];
 performance = [];
 lick_signal = [];
 for i = 1:length(sessions)
    fileName1 = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/sDATA/clicking/', sessions{i},strcat(sessions{i},'DAQdata_matlab_compatible.tdms'));
    fileName2 = fullfile('/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/sDATA/clicking/',sessions{i},strcat(sessions{i},'.tdms'));
    file = sessions{i};
    file(find(file == '-')) = [];
    if i == 2; file(end-1:end) = []; file = strcat(file,'o1');end
    [sData{i},performance{i},lick_signal{i}] = get_performance(fileName1,fileName2,file);
    total_performance_clicking(i) =  (nansum(sData{i}.imData.variables.hits)+nansum(sData{i}.imData.variables.CR))/length(unique(sData{1}.imData.variables.trials));
 end


k = 1;
for i = 1:length(data)-1
    for f = 1:length(data(i).sessionIDs)
        [fig_behavior_session,mData(i,f).behavior.performance,mData(i,f).behavior.dvalue] = plot.behavior(mData(i,f).sData);
        total_performance(k) =  (nansum(mData(i,f).sData.imData.variables.hits)+nansum(mData(i,f).sData.imData.variables.CR))/length(unique(mData(i,f).sData.imData.variables.trials));
        k = k+1;
        close all
    end
end


figure()
bar([nanmean(total_performance),nanmean(total_performance_clicking)],'FaceColor',[0.8 0.8 0.8])
hold on 
errorbar([nanmean(total_performance),nanmean(total_performance_clicking)],...
    [nanstd(total_performance),nanstd(total_performance_clicking)],'LineStyle','none','LineWidth',2,'Color',[0 0 0])
box off
yticks([0:0.1:1])
yticklabels(100*[0:0.1:1])
set(gca,'FontName','Arial','FontSize',16)
ylabel('Performance (%)')
xticks([1:2])
xticklabels({'Odor on','Odor off'})
xlim([0 3])
ax = gca;
ax.XColor = [0 0 0];
ax.YColor = [0 0 0];
ax.XLabel.Color = [0 0 0];
ax.YLabel.Color = [0 0 0];
ax.LineWidth = 1.5;

 
function [sData,performance_segments,mergedFullLickSignal] = get_performance(fileName1,fileName2,file)

fileName = fileName1;

DAQvariables=loadTDMSdata(fileName,{'Dev1port0line7','Dev1port0line6','Dev1port0line4','Dev1port0line1','Dev1port0line2','Dev1port0line3'});
frameSignal =DAQvariables.Dev1port0line7;
lickSignal  =DAQvariables.Dev1port0line4;
OdorOne     =DAQvariables.Dev1port0line1; %Methyl
OdorTwo     =DAQvariables.Dev1port0line2; %Butanol
waterValve  =DAQvariables.Dev1port0line3;

fileName = fileName2;
matFileName=simpleConvertTDMS(fileName,0);
load(matFileName{1})

trial       =eval(strcat(file,'behaveCONTROLVALVEOFFUntitled2.Data'));
odor        =eval(strcat(file,'behaveCONTROLVALVEOFFUntitled5.Data'));
responseType=eval(strcat(file,'behaveCONTROLVALVEOFFUntitled7.Data'));

%Find trials and response types
for l = 1:(max(trial))
    t{1,l} = find(trial==l); %%Find the indices for each trial
end
for i = 1:length(t)
    response(1,i)=max(responseType(t{1,i})); %% Find if hit (1) or miss (2) for each trial
end
for s = 1:length(response) %% Find if hit, miss, CR or FA for each response
    if response(1,s)==1
        hit(1,s)=1;
        miss(1,s)=0;
        FA (1,s) =0;
        CR (1,s)=0;
    elseif response (1,s)==2
        hit(1,s)=0;
        miss(1,s)=1;
        FA (1,s) =0;
        CR (1,s)=0;
    elseif response (1,s) == 3
        hit(1,s)=0;
        miss(1,s)=0;
        FA (1,s) =0;
        CR (1,s)=1;
    else
        hit(1,s)=0;
        miss(1,s)=0;
        FA (1,s) =1;
        CR (1,s)=0;
    end
end

%Find frame indices
A=diff(frameSignal);
upValues=find(A==1);
downValues=find(A==-1);
differences=vertcat(upValues,downValues);
differences=sort(differences,'ascend');
cc=0;
n=0;
for b=1:(sum(A==1)-1)
    n=n+1;
    frames(n,1)=differences(1+cc);
    frames(n,2)=differences(3+cc);
    cc=cc+2;
end
clear A
clear 'upValues'

%Find trial indices
A=diff(OdorOne);
upValuesOdorOne=find(A==1);
B=diff(OdorTwo);
upValuesOdorTwo=find(B==1);
odorOneTimes(:,1)=upValuesOdorOne;
for i = 1:length(upValuesOdorOne)
    odorOneTimes(i,2)=1;
end
odorOneTimes=odorOneTimes';
odorTwoTimes(:,1)=upValuesOdorTwo;
for i = 1:length(upValuesOdorTwo)
    odorTwoTimes(i,2)=2;
end
odorTwoTimes=odorTwoTimes';
odorsFirst=sort(horzcat(odorOneTimes, odorTwoTimes));
[temp, order] = sort(odorsFirst(2,:));
odorsFirst = odorsFirst(:,order);
odors(:,1)=odorsFirst(2,:);
odors(:,3)=odorsFirst(1,:);
clear odorOneTimes
clear odorTwoTimes
clear idx
clear indices

downValuesOdorOne=find(A==-1);
downValuesOdorTwo=find(B==-1);
odorOneTimes(:,1)=downValuesOdorOne;
for i = 1:length(downValuesOdorOne)
    odorOneTimes(i,2)=1;
end
odorOneTimes=odorOneTimes';
odorTwoTimes(:,1)=downValuesOdorTwo;
for i = 1:length(downValuesOdorTwo)
    odorTwoTimes(i,2)=2;
end
odorTwoTimes  = odorTwoTimes';
odorsSecond   = sort(horzcat(odorOneTimes, odorTwoTimes));
[temp, order] = sort(odorsSecond(2,:));
odorsSecond   = odorsSecond(:,order);
odors(:,2)    = odorsSecond(2,:);
odors(:,4)    = odorsSecond(1,:);

cc=1;
n=0;
for b=1:(length(odors)/2)
    n=n+1;
    trials(n,1)=odors(cc,1); %Select every thrid value to get onset of trial
    cc= cc+2;
end
clear A
clear B

% Assign trial starts to frames
% for k=1:length(trials)
%     A= frames(:,1)-trials(k,1);
%     B=abs(A);
%     minimum=min(B);
%     frameRow(k,:)=min(find(B(:,1)==minimum));
%     clear A
%     clear B
% end
% Find all the frames that belong to one 
% for m=1:length(trials)-1
%     allTrials(m,1)=frameRow(m,:);
%     allTrials(m,2)=frameRow(m+1,:)-1;
% end

% Get lick values
a=0;
lickSignal=lickSignal';
for ii = 1:(size(trials,1)-1) % Plot 25 Trials
    a=a+1;
    licksTrial{a,:}=lickSignal(1,trials(ii,1):(trials(ii+1)-1));
end

maxLengthCell=max(cellfun('size',licksTrial,2));  %finding the longest vector in the cell array
for i=1:length(licksTrial)
    for j=cellfun('size',licksTrial(i),2)+1:maxLengthCell
        licksTrial{i}(j)=0;   %zeropad the elements in each cell array with a length shorter than the maxlength
    end
end
mergedFullLickSignal=cell2mat(licksTrial);

for i = 1:size(mergedFullLickSignal,1)
    for ii = 1:size(mergedFullLickSignal,2)
        if mergedFullLickSignal(i,ii)==0
            mergedFullLickSignal(i,ii)=1;
        else
            mergedFullLickSignal(i,ii)=0;
        end
    end
end

sData.imData.variables.trials=trial;
sData.imData.variables.response=response;
sData.imData.variables.hits=hit;
sData.imData.variables.misses=miss;
sData.imData.variables.FA=FA;
sData.imData.variables.CR=CR;
% sData.imData.variables.trialFrames=frames;
sData.imData.variables.trialStartIndex=trials;
% sData.imData.variables.trialIndices=allTrials;
sData.imData.variables.trialLicks=mergedFullLickSignal;
sData.imData.variables.odors=odors;

%Create Behavior Figure

k=0;
k = k+1;
figure('units','normalized','outerposition',[0 0 1 1])
% Get file and values

% fileName= [Path.processed,filesep,'imaging',filesep,experiment(f).name,filesep,'labviewdata',filesep,experiment(f).IDbehave,'.tdms'];
% fileName= [Path.external,filesep,experiment(f).externalDate, filesep, experiment(f).name,filesep,'labviewdata',filesep,experiment(f).IDbehave,'.tdms'];
% matFileName=simpleConvertTDMS(fileName,0);
% load(matFileName{1})

sData.imData.variables.paradigm=eval(strcat(file,'behaveCONTROLVALVEOFFUntitled.Data'))';
sData.imData.variables.stage   =eval(strcat(file,'behaveCONTROLVALVEOFFUntitled1.Data'))';
sData.imData.variables.trial   =eval(strcat(file,'behaveCONTROLVALVEOFFUntitled2.Data'))';
sData.imData.variables.lick    =eval(strcat(file,'behaveCONTROLVALVEOFFUntitled3.Data'))';
sData.imData.variables.time    =eval(strcat(file,'behaveCONTROLVALVEOFFUntitled4.Data'))';
sData.imData.variables.odor    =eval(strcat(file,'behaveCONTROLVALVEOFFUntitled5.Data'))';
sData.imData.variables.learning=eval(strcat(file,'behaveCONTROLVALVEOFFUntitled6.Data'))';
sData.imData.variables.responseType=eval(strcat(file,'behaveCONTROLVALVEOFFUntitled7.Data'))';

totalTrials(1,:)= sData.imData.variables.hits;
totalTrials(2,:)=sData.imData.variables.misses;
totalTrials(3,:)=sData.imData.variables.CR;
totalTrials(4,:)=sData.imData.variables.FA;

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
%Sliding window
for p=1:length(sData.imData.variables.hits)
    cc=cc+1;
    try
        performance_segments (1,cc)= ((sum(sData.imData.variables.hits(1,p:p+24))+sum(sData.imData.variables.CR(1,p:p+24)))/25)*100;
    catch
        performance_segments (1,cc)= ((sum(sData.imData.variables.hits(1,p:length(sData.imData.variables.hits)))+sum(sData.imData.variables.CR(1,p:length(sData.imData.variables.hits))))/(length(sData.imData.variables.hits)-p))*100;
    end
end

lengthSegments =1:length(performance_segments);
plot(lengthSegments,performance_segments,'Color', [0/255 126/255 135/255], 'linewidth', 2)
hold on
line([length(sData.imData.variables.hits)-25 length(sData.imData.variables.hits)-25],[0 100])
ylim([0 100])
xlim([1 length(lengthSegments)])
ylabel('performance %')
legend ('performance=(#hit+#CR)/#trials')

% Plot d'
k=k+1;
subplot(2,3,k)
cc=0;
for p=1:length(sData.imData.variables.hits)
    cc=cc+1;
    try
        hitRate_segments (1,cc)=(sum(sData.imData.variables.hits(1,p:p+24)))/25;
    catch
        hitRate_segments (1,cc)=(sum(sData.imData.variables.hits(1,p:length(sData.imData.variables.hits))))/25;
    end
    try
        CRRate_segments (1,cc)=(sum(sData.imData.variables.CR(1,p:p+24)))/25;
    catch
        CRRate_segments (1,cc)=(sum(sData.imData.variables.CR(1,p:length(sData.imData.variables.hits))))/25;
    end
    try
        FARate_segments (1,cc)=(sum(sData.imData.variables.FA(1,p:p+24)))/25;
    catch
        FARate_segments (1,cc)=(sum(sData.imData.variables.FA(1,p:length(sData.imData.variables.hits))))/25;
    end
end

hitRate_segments (hitRate_segments ==0)=0.5;
hitRate_segments (hitRate_segments ==1)=(24-0.5);
FARate_segments (FARate_segments ==0)=0.5;
FARate_segments (FARate_segments ==1)=(24-0.5);
cc=0;
for cc = 1:length(sData.imData.variables.hits)
    cc=cc+1;
    try
        dvalue_paper (1,cc) = mean(norminv(hitRate_segments (1,cc:cc+24),0,1)-norminv(FARate_segments (1,cc:cc+24),0,1));
    catch
        dvalue_paper (1,cc) = mean(norminv(hitRate_segments (1,cc:length(sData.imData.variables.hits)),0,1)-norminv(FARate_segments (1,cc:length(sData.imData.variables.hits)),0,1));
    end
end
lengthSegments=1:(length(sData.imData.variables.hits)+1);
plot(lengthSegments,dvalue_paper,'Color', [243/255 197/255 43/255], 'linewidth', 2)
hold on
line([length(sData.imData.variables.hits)-25 length(sData.imData.variables.hits)-25],[0 2])
xlim([1 length(lengthSegments)])
ylim([0 2])
ylabel('dPrime')
legend('dPrime')

% Plot Licking Rate
k=k+1;
subplot(2,3,k)
for n = 1:length(sData.imData.variables.hits) %%Lick count in each stage
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
lick_rate_first =mean(mergedLickRate((1:length(sData.imData.variables.hits)/2),:));
plot(lick_rate_first,'Color', [198/255 44/255 58/255], 'linewidth', 0.5) %% Adjust here with correct position of the line!!!
hold on
lick_rate_second =mean(mergedLickRate((length(sData.imData.variables.hits)/2):length(sData.imData.variables.hits)/2,:));
plot(lick_rate_second,'Color', [60/255 85/255 123/255], 'linewidth', 0.5) %% Adjust here with correct position of the line!!!
ylabel('average spike count')

%% Plot lick response yes/no
k=k+1;
subplot(2,3,k)
for n = 1:length(sData.imData.variables.hits) %%Lick count in each stage
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
scatter(1:length(sData.imData.variables.hits),lickYesNo(1,:),'filled')
hold on
scatter(1:length(sData.imData.variables.hits),lickYesNo(2,:),'filled')
hold on
scatter(1:length(sData.imData.variables.hits),lickYesNo(3,:),'filled')
hold on
scatter(1:length(sData.imData.variables.hits),lickYesNo(4,:),'filled')
hold on
scatter(1:length(sData.imData.variables.hits),lickYesNo(5,:),'filled')
legend('lick odor1', 'lick delay', 'lick odor2', 'lick response', 'lick ITI')
xlabel('trial')
ylabel('response type')
close all
end
