function ClassifiedCells = cellClassificationGolshani_shuffle(sData)

% load(fullfile(Path.processed,filesep,'imaging',filesep,experiment(f).name,filesep,'sData', 'sData.mat'))
% load(fullfile(Path.external,filesep,experiment(f).externalDate, filesep, experiment(f).name,filesep,'sData', 'sData.mat'))
rng(5);
%Assign the trials to the 4 categories

parameters = classification.get_parameters;

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

numShuffles = 1;
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


    trialsButanolciaDeconv= [signalButBut ITIsignalButBut; signalButMet ITIsignalButMet];


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

    binnedTrialsButanolciaDeconv(:,39:39+25) =[];
    
    trialsMethylciaDeconv= [signalMetMet ITIsignalMetMet; signalMetBut ITIsignalMetBut];
    
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
    
    binnedTrialsMethylciaDeconv(:,39:39+25) =[];
    %Butanol
    %     trialsButanolciaDeconv= [signalButBut; signalButMet];
    
%     binnedTrialsButanolciaDeconv= Classification{roi,4};
    A = repmat(binnedTrialsButanolciaDeconv, [1, 1, numShuffles]);
    [m,n,p]=size(A);
    [I,J]=ndgrid(1:m,1:n);
    idx = [];
    for kk = 1:numShuffles
        
        RowsShift = randi(round(size(binnedTrialsButanolciaDeconv, 2)/2),size(binnedTrialsButanolciaDeconv, 1), 1);
        Jshift=mod(J-RowsShift-1,n)+1;
        idx(:,:,kk)=sub2ind([m,n], I,Jshift);
    end
    
    binnedTrialsButanolciaDeconv = A(idx);
    
    idx = 1:38;
    averageButanolDelay=nanmean(binnedTrialsButanolciaDeconv(:,1:38,:)); %Find max value and time bin
    [~,indexMaxAverageButanolDelay]=nanmax(averageButanolDelay,[],2);
    indexMaxAverageButanolDelay=indexMaxAverageButanolDelay(:);
    
    indexMaxAverageButanolDelay = indexMaxAverageButanolDelay(:);
    for pp = 1:length(indexMaxAverageButanolDelay)
        spikeResponse(pp) = length(find(binnedTrialsButanolciaDeconv(:,indexMaxAverageButanolDelay(pp),pp)));
        butanolTimeCell{roi,pp,1}=0;
        butanolTimeCell{roi,pp,2}=0;
        butanolTimeCell{roi,pp,4} = binnedTrialsButanolciaDeconv(:,:,pp);
        
    end
    
    
    spikingRoi(roi,1:numShuffles) = spikeResponse>(size(binnedTrialsButanolciaDeconv,1)/100)*10;
    
    idx_sign = find(spikingRoi(roi,:));
    if ~isempty(idx_sign)
        for pp = 1:length(idx_sign)
            shiftedButanolDeconv =[];
            %     if spikingRoi(roi,)==1
            
            butanol_temp = binnedTrialsButanolciaDeconv(:,:,idx_sign(pp));
            shiftedButanolDeconv =[];
            for ii=1:size(binnedTrialsButanolciaDeconv,1)
                shiftsignal=butanol_temp(ii,1:38);
                
                % Circshift all rows simultaneously
                shiftsignal_dummy = repmat(shiftsignal, 1000, 1);
                [m,n]=size(repmat(shiftsignal, 1000, 1));
                [I,J]=ndgrid(1:m,1:n);
                r = randi(round(size(butanol_temp, 2)/2, 1000), 1);
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
            if averageButanolDelay(1, indexMaxAverageButanolDelay(idx_sign(pp))) > prctile(mean_shiftedButanolDeconv(idx_sign(pp),indexMaxAverageButanolDelay(idx_sign(pp))),95)
                butanolTimeCell{roi,idx_sign(pp),1}=1;
                if indexMaxAverageButanolDelay(idx_sign(pp)) >6 && indexMaxAverageButanolDelay(idx_sign(pp)) <38
                    butanolTimeCell{roi,idx_sign(pp),2}=1;
                else
                    butanolTimeCell{roi,idx_sign(pp),2}=2;
                end
                %         else
                %             butanolTimeCell{roi,idx_sign(pp),1}=0;
                %             butanolTimeCell{roi,idx_sign(pp),2}=0;
            end
            %     else
            %         butanolTimeCell{roi,1}=0;
            %         butanolTimeCell{roi,2}=0;
        end
    end
    clear spikeResponse
    
    
%     binnedTrialsMethylciaDeconv= Classification{roi,8};
    
    A = repmat(binnedTrialsMethylciaDeconv, [1, 1, numShuffles]);
    [m,n,p]=size(A);
    [I,J]=ndgrid(1:m,1:n);
    idx = [];
    for kk = 1:numShuffles
        
        RowsShift = randi(round(size(binnedTrialsMethylciaDeconv, 2)/2),size(binnedTrialsMethylciaDeconv, 1), 1);
        Jshift=mod(J-RowsShift-1,n)+1;
        idx(:,:,kk)=sub2ind([m,n], I,Jshift);
    end
    
    binnedTrialsMethylciaDeconv = A(idx);
    
    
    idx = 1:38;
    averageMethylDelay=nanmean(binnedTrialsMethylciaDeconv(:,1:38,:)); %Find max value and time bin
    [~,indexMaxAverageMethylDelay]=nanmax(averageMethylDelay,[],2);
    
    indexMaxAverageMethylDelay = indexMaxAverageMethylDelay(:);
    for pp = 1:length(indexMaxAverageButanolDelay)
        spikeResponse(pp) = length(find(binnedTrialsMethylciaDeconv(:,indexMaxAverageMethylDelay(pp),pp)));
        methylTimeCell{roi,pp,1}=0;
        methylTimeCell{roi,pp,2}=0;
        methylTimeCell{roi,pp,4} = binnedTrialsMethylciaDeconv(:,:,pp);
    end
    
    
    spikingRoi(roi,1:numShuffles) = spikeResponse>(size(binnedTrialsMethylciaDeconv,1)/100)*10;
    
    idx_sign = find(spikingRoi(roi,:));
    if ~isempty(idx_sign)
        for pp = 1:length(idx_sign)
            %     if spikingRoi(roi,)==1
            
            butanol_temp = binnedTrialsMethylciaDeconv(:,:,idx_sign(pp));
            shiftedMethylDeconv =[];
            for ii=1:size(binnedTrialsMethylciaDeconv,1)
                shiftsignal=butanol_temp(ii,1:38);
                
                % Circshift all rows simultaneously
                shiftsignal_dummy = repmat(shiftsignal, 1000, 1);
                [m,n]=size(repmat(shiftsignal, 1000, 1));
                [I,J]=ndgrid(1:m,1:n);
                r = randi(round(size(butanol_temp, 2)/2), 1000, 1);
                Jshift=mod(J-r-1,n)+1;
                idx=sub2ind([m,n], I,Jshift);
                shiftedMethyl = shiftsignal_dummy(idx);
                
                shiftedMethylDeconv(1:1000,ii,1:38)= shiftedMethyl;
                
            end
            
            mean_shiftedMethylDeconv = reshape(nanmean(shiftedMethylDeconv,2),1000,38);
            
            if averageButanolDelay(1, indexMaxAverageMethylDelay(idx_sign(pp))) > prctile(mean_shiftedMethylDeconv(idx_sign(pp),indexMaxAverageMethylDelay(idx_sign(pp))),95)
                butanolTimeCell{roi,idx_sign(pp),1}=1;
                if indexMaxAverageMethylDelay(idx_sign(pp)) >6 && indexMaxAverageMethylDelay(idx_sign(pp)) <38
                    methylTimeCell{roi,idx_sign(pp),2}=1;
                else
                    methylTimeCell{roi,idx_sign(pp),2}=2;
                end
                
            end
            
        end
    end
    clear spikeResponse
    
end

ClassifiedCells=[reshape(butanolTimeCell,length(butanolTimeCell),4) ...
                 reshape(methylTimeCell,length(methylTimeCell),4)];

