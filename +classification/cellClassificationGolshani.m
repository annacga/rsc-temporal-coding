function ClassifiedCells = cellClassificationGolshani(sData)

% load(fullfile(Path.processed,filesep,'imaging',filesep,experiment(f).name,filesep,'sData', 'sData.mat'))
% load(fullfile(Path.external,filesep,experiment(f).externalDate, filesep, experiment(f).name,filesep,'sData', 'sData.mat'))
rng(5)
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
        butbutLick(bb,:)=sData.imData.variables.trialLicks(kk,:);
    end
    if sData.imData.variables.odors(k,3)==2 && sData.imData.variables.odors(k+1,3)==1
        bm=bm+1;
        butMet(bm,1:2)=sData.imData.variables.trialIndices(kk,:);
        butMet(bm,3)=sData.imData.variables.response(1,kk);
        butmetLick(bm,:)=sData.imData.variables.trialLicks(kk,:);
    end
    if sData.imData.variables.odors(k,3)==1 && sData.imData.variables.odors(k+1,3)==1
        mm=mm+1;
        metMet(mm,1:2)=sData.imData.variables.trialIndices(kk,:);
        metMet(mm,3)=sData.imData.variables.response(1,kk);
        metmetLick(mm,:)=sData.imData.variables.trialLicks(kk,:);
    end
    if sData.imData.variables.odors(k,3)==1 && sData.imData.variables.odors(k+1,3)==2
        mb=mb+1;
        metBut(mb,1:2)=sData.imData.variables.trialIndices(kk,:);
        metBut(mb,3)=sData.imData.variables.response(1,kk);
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

parameters = classification.get_parameters;
for roi=1:size(signal,1)
%     roi
    for ii=1:length(butBut)
        A= signal(roi,butBut(ii,1):butBut(ii,1)+parameters.plottingWidth+31);
        signalButBut(ii,:) = A;
        B=signal(roi,butBut(ii,2)-parameters.ITIWidth:butBut(ii,2));
        ITIsignalButBut(ii,:)=B;
    end
    for ii=1:length(butMet)
        A= signal(roi,butMet(ii,1):butMet(ii,1)+parameters.plottingWidth+31);
        signalButMet(ii,:) = A;
        B=signal(roi,butMet(ii,2)-parameters.ITIWidth:butMet(ii,2));
        ITIsignalButMet(ii,:)=B;
    end
    for ii=1:length(metMet)
        A= signal(roi,metMet(ii,1):metMet(ii,1)+parameters.plottingWidth+31);
        signalMetMet(ii,:) = A;
        B=signal(roi,metMet(ii,2)-parameters.ITIWidth:metMet(ii,2));
        ITIsignalMetMet(ii,:)=B;
    end
    for ii=1:length(metBut)
        A= signal(roi,metBut(ii,1):metBut(ii,1)+parameters.plottingWidth+31);
        signalMetBut(ii,:) = A;
        B=signal(roi,metBut(ii,2)-parameters.ITIWidth:metBut(ii,2));
        ITIsignalMetBut(ii,:)=B;
    end
    
    %Butanol
    trialsButanolciaDeconv= [signalButBut; signalButMet];
    

    for iii = 1:size(trialsButanolciaDeconv,1) %Bin data into 320ms with 50% overlay
        b=1;
        a=1;
        for ii =1:5:size(trialsButanolciaDeconv(iii,:),2)
            try
                binnedTrialsButanolciaDeconv(iii,b)=nansum(trialsButanolciaDeconv(iii,ii:a+10));
                a=a+5;
                b=b+1;
            catch
                binnedTrialsButanolciaDeconv(iii,b)=nansum(binnedTrialsButanolciaDeconv(iii,ii:end));
                b=b+1;
            end
        end
    end
    
    idx = 1:38;
    averageButanolDelay=nanmean(binnedTrialsButanolciaDeconv(:,1:38)); %Find max value and time bin
    maxAverageButanolDelay=max(averageButanolDelay);
    indexMaxAverageButanolDelay=find(averageButanolDelay==maxAverageButanolDelay);
    if isempty(indexMaxAverageButanolDelay)
        indexMaxAverageButanolDelay = 1;
    end
    indexMaxAverageButanolDelay=indexMaxAverageButanolDelay(1,1);
    indexMaxAverageSignal=idx(indexMaxAverageButanolDelay);
    
    spikeResponse = [];
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
    
    shiftedButanolDeconv =[];
    if spikingRoi(roi,1)==1
%         for ii=1:size(binnedTrialsButanolciaDeconv,1)
%             shiftsignal=binnedTrialsButanolciaDeconv(ii,1:38);
% %             for i=1:1000
% %                 r=randi(size(binnedTrialsButanolciaDeconv,2),1);
% %                 shiftedButanol(i,:)=circshift(shiftsignal,r);
% %             end
% 
%              shiftsignal_dummy = repmat(shiftsignal, 1000, 1);
%              [m,n]=size(repmat(shiftsignal, 1000, 1));
%              [I,J]=ndgrid(1:m,1:n);
%              r = randi(size(binnedTrialsButanolciaDeconv, 2), 1000, 1);
%              Jshift=mod(J-r-1,n)+1;
%              idx=sub2ind([m,n], I,Jshift);
%              shiftedButanol = shiftsignal_dummy(idx);
%             
%             shiftedButanolDeconv(ii,:)=mean(shiftedButanol);
%             clear shiftedButanol
%             clear shiftsignal
%         end
        
          shiftedButanolDeconv =[];
         for ii=1:size(binnedTrialsButanolciaDeconv,1)
             shiftsignal=binnedTrialsButanolciaDeconv(ii,1:38);
             
             % Circshift all rows simultaneously
             shiftsignal_dummy = repmat(shiftsignal, 1000, 1);
             [m,n]=size(repmat(shiftsignal, 1000, 1));
             [I,J]=ndgrid(1:m,1:n);
             r = randi(size(binnedTrialsButanolciaDeconv, 2), 1000, 1);
             Jshift=mod(J-r-1,n)+1;
             idx=sub2ind([m,n], I,Jshift);
             shiftedButanol = shiftsignal_dummy(idx);
    
             shiftedButanolDeconv(1:1000,ii,1:38)= shiftedButanol;
             % shiftedMethyl(i,:)=circshift(shiftSignal,r);% Make standard values 589=length of whole trial
           %    clear shiftedMethyl
            %   clear shiftsignal
         end
        
        mean_shiftedButanolDeconv = reshape(nanmean(shiftedButanolDeconv,2),1000,38);
         %     
        
        %         maxButanolShuffled(roi,1)=find(mean(shiftedButanolDeconv)==max(mean(shiftedButanolDeconv)));
        if averageButanolDelay(1, indexMaxAverageButanolDelay) > prctile(mean_shiftedButanolDeconv(:,indexMaxAverageSignal),95)
            butanolTimeCell{roi,1}=1;
            if indexMaxAverageButanolDelay >6 && indexMaxAverageButanolDelay <38
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
                binnedTrialsMethylciaDeconv(iii,b)=nansum(trialsMethylciaDeconv(iii,ii:a+10));
                a=a+5;
                b=b+1;
            catch
                binnedTrialsMethylciaDeconv(iii,b)=nansum(binnedTrialsMethylciaDeconv(iii,ii:end));
                b=b+1;
            end
        end
    end
    
    idx =  1:38;
    averageMethylDelay=nanmean(binnedTrialsMethylciaDeconv(:,1:38)); %Find max value and time bin
    maxAverageMethylDelay=max(averageMethylDelay);
    indexMaxAverageMethylDelay=find(averageMethylDelay==maxAverageMethylDelay);
    if isempty(indexMaxAverageMethylDelay)
       indexMaxAverageMethylDelay = 1;
    end
    indexMaxAverageMethylDelay=indexMaxAverageMethylDelay(1,1);
    indexMaxAverageSignal=idx(indexMaxAverageMethylDelay);
    
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
    


     shiftedMethylDeconv =[];
     if spikingRoi(roi,2)==1
         
         
         for ii=1:size(binnedTrialsMethylciaDeconv,1)
             shiftsignal=binnedTrialsMethylciaDeconv(ii,1:38);
             
             % Circshift all rows simultaneously
             shiftsignal_dummy = repmat(shiftsignal, 1000, 1);
             [m,n]=size(repmat(shiftsignal, 1000, 1));
             [I,J]=ndgrid(1:m,1:n);
             r = randi(size(binnedTrialsMethylciaDeconv, 2), 1000, 1);
             Jshift=mod(J-r-1,n)+1;
             idx=sub2ind([m,n], I,Jshift);
             shiftedMethyl = shiftsignal_dummy(idx);
    
             shiftedMethylDeconv(1:1000,ii,1:38)= shiftedMethyl ;
             % shiftedMethyl(i,:)=circshift(shiftSignal,r);% Make standard values 589=length of whole trial
           %    clear shiftedMethyl
            %   clear shiftsignal
         end
        
        mean_shiftedMethyDeconv = reshape(nanmean(shiftedMethylDeconv,2),1000,38);
         %         end
         if averageMethylDelay(1, indexMaxAverageMethylDelay) > prctile(mean_shiftedMethyDeconv(:,indexMaxAverageSignal),95)
             methylTimeCell{roi,1}=1;
             if indexMaxAverageMethylDelay>6 && indexMaxAverageMethylDelay<38
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
    
%     butanolTimeCell{roi,3} = sData.imData.roiSignals.rois(1,roi).uid;
%     methylTimeCell{roi,3}  = sData.imData.roiSignals.rois(1,roi).uid;
    butanolTimeCell{roi,4} = binnedTrialsButanolciaDeconv;
    methylTimeCell{roi,4}  = binnedTrialsMethylciaDeconv;
    
end

ClassifiedCells=[butanolTimeCell methylTimeCell];

