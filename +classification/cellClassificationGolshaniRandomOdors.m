function [timeCellsButanol, timeCellsMethyl] = cellClassificationGolshaniRandomOdors(sData)

% load(fullfile(Path.processed,filesep,'imaging',filesep,experiment(f).name,filesep,'sData', 'sData.mat'))
% load(fullfile(Path.external,filesep,experiment(f).externalDate, filesep, experiment(f).name,filesep,'sData', 'sData.mat'))

%Assign the trials to the 4 categories
k=1;
kk=0;
bb=0;
bm=0;
mm=0;
mb=0;
for i=1:length(sData.imData.variables.trialIndices)
    kk=kk+1;
    if sData.imData.variables.odors(k,3)==2 && sData.imData.variables.odors(k+1,3)==2
        bb=bb+1;
        butBut(bb,1:2)=sData.imData.variables.trialIndices(kk,:);
        butBut(bb,3)=sData.imData.variables.response(1,kk);
        butBut(bb,4)=round((sData.imData.variables.trialIndices(kk,2)-sData.imData.variables.trialIndices(kk,1))/31);
        butbutLick(bb,:)=sData.imData.variables.trialLicks(kk,:);
    end
    if sData.imData.variables.odors(k,3)==2 && sData.imData.variables.odors(k+1,3)==1
        bm=bm+1;
        butMet(bm,1:2)=sData.imData.variables.trialIndices(kk,:);
        butMet(bm,3)=sData.imData.variables.response(1,kk);
        butMet(bm,4)=round((sData.imData.variables.trialIndices(kk,2)-sData.imData.variables.trialIndices(kk,1))/31);
        butmetLick(bm,:)=sData.imData.variables.trialLicks(kk,:);
    end
    if sData.imData.variables.odors(k,3)==1 && sData.imData.variables.odors(k+1,3)==1
        mm=mm+1;
        metMet(mm,1:2)=sData.imData.variables.trialIndices(kk,:);
        metMet(mm,3)=sData.imData.variables.response(1,kk);
        metMet(mm,4)=round((sData.imData.variables.trialIndices(kk,2)-sData.imData.variables.trialIndices(kk,1))/31);
        metmetLick(mm,:)=sData.imData.variables.trialLicks(kk,:);
    end
    if sData.imData.variables.odors(k,3)==1 && sData.imData.variables.odors(k+1,3)==2
        mb=mb+1;
        metBut(mb,1:2)=sData.imData.variables.trialIndices(kk,:);
        metBut(mb,3)=sData.imData.variables.response(1,kk);
        metBut(mb,4)=round((sData.imData.variables.trialIndices(kk,2)-sData.imData.variables.trialIndices(kk,1))/31);
        metbutLick(mb,:)=sData.imData.variables.trialLicks(kk,:);
    end
    k=k+2;
end

whichSignal = 'deconvolved';
switch whichSignal
    case 'deconvolved'
        signal = sData.imData.roiSignals.deconv;
    case 'dff'
        signal=sData.imData.roiSignals.dff;
end

for roi=1:size(signal,1)
     roi
    signalButBut=zeros(length(butBut),max(butBut(:,4))*31);
    signalButBut_deconv=zeros(length(butBut),max(butBut(:,4))*31);
    for ii=1:length(butBut)
        A= signal(roi,butBut(ii,1):butBut(ii,2));
        B=[A zeros(1,(max(butBut(:,4))*31)-length(A))];
        signalButBut(ii,:) = B;
        C= signal(roi,butBut(ii,1):butBut(ii,2));
        D=[C zeros(1,(max(butBut(:,4))*31)-length(C))];
        signalButBut_deconv(ii,:) = D;
        clear C
        clear D
        clear A
        clear B
    end
    [~,idx] = sort(butBut(:,4)); % sort just the first column
signalButBut =signalButBut(idx,:);
signalButBut_deconv=signalButBut_deconv(idx,:);

 signalButMet=zeros(length(butMet),max(butMet(:,4))*31);
    signalButMet_deconv=zeros(length(butMet),max(butMet(:,4))*31);
    for ii=1:length(butMet)
        A= signal(roi,butMet(ii,1):butMet(ii,2));
        B=[A zeros(1,(max(butMet(:,4))*31)-length(A))];
        signalButMet(ii,:) = B;
        C= signal(roi,butMet(ii,1):butMet(ii,2));
        D=[C zeros(1,(max(butMet(:,4))*31)-length(C))];
        signalButMet_deconv(ii,:) = D;
        clear C
        clear D
        clear A
        clear B
    end
    [~,idx] = sort(butMet(:,4)); % sort just the first column
signalButMet =signalButMet(idx,:); 
signalButMet_deconv=signalButMet_deconv(idx,:);

 signalMetMet=zeros(length(metMet),max(metMet(:,4))*31);
    signalMetMet_deconv=zeros(length(metMet),max(metMet(:,4))*31);
    for ii=1:length(metMet)
        A= signal(roi,metMet(ii,1):metMet(ii,2));
        B=[A zeros(1,(max(metMet(:,4))*31)-length(A))];
        signalMetMet(ii,:) = B;
        C= signal(roi,metMet(ii,1):metMet(ii,2));
        D=[C zeros(1,(max(metMet(:,4))*31)-length(C))];
        signalMetMet_deconv(ii,:) = D;
        clear C
        clear D
        clear A
        clear B
    end
        [~,idx] = sort(metMet(:,4)); % sort just the first column
signalMetMet =signalMetMet(idx,:); 
signalMetMet_deconv=signalMetMet_deconv(idx,:);

signalMetBut=zeros(length(metBut),max(metBut(:,4))*31);
    signalMetBut_deconv=zeros(length(metBut),max(metBut(:,4))*31);
    for ii=1:length(metBut)
        A= signal(roi,metBut(ii,1):metBut(ii,2));
        B=[A zeros(1,(max(metBut(:,4))*31)-length(A))];
        signalMetBut(ii,:) = B;
         C= signal(roi,metBut(ii,1):metBut(ii,2));
        D=[C zeros(1,(max(metBut(:,4))*31)-length(C))];
        signalMetMet_deconv(ii,:) = D;
        clear C
        clear D
        clear A
        clear B
    end
         [~,idx] = sort(metBut(:,4)); % sort just the first column
signalMetBut =signalMetBut(idx,:);
signalMetMet_deconv=signalMetMet_deconv(idx,:);

    %Butanol
    trialsButanolciaDeconv= [signalButBut; signalButMet];

    for iii = 1:size(trialsButanolciaDeconv,1) %Bin data into 320ms with 50% overlay
        b=1;
        a=1;
        for ii =1:5:size(trialsButanolciaDeconv(iii,:),2)
            try
                binnedTrialsButanolciaDeconv(iii,b)=sum(trialsButanolciaDeconv(iii,ii:a+10));
                a=a+5;
                b=b+1;
            catch
                binnedTrialsButanolciaDeconv(iii,b)=sum(binnedTrialsButanolciaDeconv(iii,ii:end));
                b=b+1;
            end
        end
    end
    
    averageButanolDelay=mean(binnedTrialsButanolciaDeconv(:,1:21)); %Find max value and time bin
    maxAverageButanolDelay=max(averageButanolDelay);
    indexMaxAverageButanolDelay=find(averageButanolDelay==maxAverageButanolDelay);
    indexMaxAverageButanolDelay=indexMaxAverageButanolDelay(1,1);
    
    for ii=1:size(trialsButanolciaDeconv,1)
        if binnedTrialsButanolciaDeconv(ii,indexMaxAverageButanolDelay)>0
            spikeResponse(1,ii)=1;
        else
            spikeResponse(1,ii)=0;
        end
    end
    
    if sum(spikeResponse)>((size(trialsButanolciaDeconv,1)/100)*10) %Without the 3 trials criterion
        %     if sum(spikeResponse)>3 || sum(spikeResponse)>((size(trialsButanolciaDeconv,1)/100)*10)
        spikingRoi(roi,1)=1;
    else
        spikingRoi(roi,1)=0;
    end
    
    if spikingRoi(roi,1)==1
        for ii=1:size(binnedTrialsButanolciaDeconv,1)
            shiftsignal=binnedTrialsButanolciaDeconv(ii,1:21);
            for i=1:1000
                a = 1;
                b= 21.8/2;
                r=round((b-a).*rand(1,1)+a);
                if mod(ii,2)
                    r=r;
                else
                    r = r*(-1);
                end
                shiftedButanol(i,:)=circshift(shiftsignal,r);
            end
            shiftedButanolDeconv(ii,:)=mean(shiftedButanol);
            clear shiftedButanol
            clear shiftsignal
        end
        %         maxButanolShuffled(roi,1)=find(mean(shiftedButanolDeconv)==max(mean(shiftedButanolDeconv)));
        if averageButanolDelay(1, indexMaxAverageButanolDelay) > prctile(mean(shiftedButanolDeconv),99)
            butanolTimeCell{roi,1}=1;
            if indexMaxAverageButanolDelay >6 && indexMaxAverageButanolDelay <21
                butanolTimeCell{roi,2}=1;
            else
                butanolTimeCell{roi,2}=2;
            end
        else
            butanolTimeCell{roi,1}=0;
            butanolTimeCell{roi,2}=0;
        end
    else
        butanolTimeCell{roi,1}=0;
        butanolTimeCell{roi,2}=0;
    end
    clear spikeResponse
    
    %Methyl
    trialsMethylciaDeconv= [signalMetMet; signalMetBut];

    for iii = 1:size(trialsMethylciaDeconv,1) %Bin data into 320ms with 50% overlay
        b=1;
        a=1;
        %         for ii =round(1:2.5:size(trialsMethylciaDeconv(iii,:),2))
        for ii =1:5:size(trialsMethylciaDeconv(iii,:),2)
            try
                binnedTrialsMethylciaDeconv(iii,b)=sum(trialsMethylciaDeconv(iii,ii:a+10));
                a=a+5;
                b=b+1;
            catch
                binnedTrialsMethylciaDeconv(iii,b)=sum(binnedTrialsMethylciaDeconv(iii,ii:end));
                b=b+1;
            end
        end
    end
    
    averageMethylDelay=mean(binnedTrialsMethylciaDeconv(:,1:21)); %Find max value and time bin
    maxAverageMethylDelay=max(averageMethylDelay);
    indexMaxAverageMethylDelay=find(averageMethylDelay==maxAverageMethylDelay);
    indexMaxAverageMethylDelay=indexMaxAverageMethylDelay(1,1);
    
    for ii=1:size(trialsMethylciaDeconv,1)
        if binnedTrialsMethylciaDeconv(ii,indexMaxAverageMethylDelay)>0
            spikeResponse(1,ii)=1;
        else
            spikeResponse(1,ii)=0;
        end
    end
    
        if sum(spikeResponse)>((size(trialsMethylciaDeconv,1)/100)*10) %Without the 3 trials criterion
%     if sum(spikeResponse)>3 || sum(spikeResponse)>((size(trialsMethylciaDeconv,1)/100)*10)
        spikingRoi(roi,2)=1;
    else
        spikingRoi(roi,2)=0;
    end
    
    if spikingRoi(roi,2)==1
        for ii=1:size(binnedTrialsMethylciaDeconv,1)
            shiftSignal=binnedTrialsMethylciaDeconv(ii,1:38);
            for i=1:1000
                a = 1;
                b= 21/2;
                r=round((b-a).*rand(1,1)+a);
                if mod(ii,2)
                    r= r;
                else
                    r = r*(-1);
                end
                shiftedMethyl(i,:)=circshift(shiftSignal,r);% Make standard values 589=length of whole trial
            end
            shiftedMethylDeconv(ii,:)=mean(shiftedMethyl);
            clear shiftedMethyl
            clear shiftsignal
        end
        %         maxMethylShuffled(roi,1)=find(mean(shiftedMethylDeconv)==max(mean(shiftedMethylDeconv)));
        if averageMethylDelay(1, indexMaxAverageMethylDelay) > prctile(mean(shiftedMethylDeconv),99)
            methylTimeCell{roi,1}=1;
            if indexMaxAverageMethylDelay>6 && indexMaxAverageMethylDelay<21
                methylTimeCell{roi,2}=1;
            else
                methylTimeCell{roi,2}=2;
            end
        else
            methylTimeCell{roi,1}=0;
            methylTimeCell{roi,2}=0;
        end
    else
        methylTimeCell{roi,1}=0;
        methylTimeCell{roi,2}=0;
        
    end
    clear spikeResponse
    
    butanolTimeCell{roi,3}=sData.imData.roiSignals.rois(1,roi).uid;
    methylTimeCell{roi,3}=sData.imData.roiSignals.rois(1,roi).uid;
    
end

ClassifiedCells=[butanolTimeCell methylTimeCell];