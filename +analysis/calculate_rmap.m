function [oderAA_reponse,oderAB_reponse,oderBA_reponse,oderBB_reponse ]=calculate_rmap(sData,signal,roi)

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
            butBut(bb,1:2)  =sData.imData.variables.trialIndices(kk,:);
            butBut(bb,3)    =sData.imData.variables.response(1,kk);
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
    
        for ii=1:length(butBut)
%             if butBut(ii,1)-155 < 1
%                 A_before= signal(roi,1:butBut(ii,1)-1);
%                 A_before = [NaN(1,abs(butBut(ii,1)-156)) A_before];
%                 signalButBut_before(ii,:) = A_before;
%             else
%                 A_before= signal(roi,butBut(ii,1)-155:butBut(ii,1)-1);
%                 signalButBut_before(ii,:) = A_before;
%             end
            A= signal(roi,butBut(ii,1):butBut(ii,1)+parameters.plottingWidth);
            signalButBut(ii,:) = A;
            B=signal(roi,butBut(ii,2)-parameters.ITIWidth:butBut(ii,2));
            ITIsignalButBut(ii,:)=B;
        end
        %         signalButBut( ~any(signalButBut,2), : ) = [];
        for ii=1:length(butMet)
%             if butMet(ii,1)-155 < 1
%                 A_before= signal(roi,1:butMet(ii,1)-1);
%                 A_before = [NaN(1,abs(butMet(ii,1)-156)) A_before];
%                 signalbutMet_before(ii,:) = A_before;
%             else
%                 A_before= signal(roi,butMet(ii,1)-155:butMet(ii,1)-1);
%                 signalButMet_before(ii,:) = A_before;
%             end
            A= signal(roi,butMet(ii,1):butMet(ii,1)+parameters.plottingWidth);
            signalButMet(ii,:) = A;
            B=signal(roi,butMet(ii,2)-parameters.ITIWidth:butMet(ii,2));
            ITIsignalButMet(ii,:)=B;
        end
        %         signalButMet( ~any(signalButMet,2), : ) = [];
        for ii=1:length(metMet)
%             if metMet(ii,1)-155 < 1
%                 A_before= signal(roi,1:metMet(ii,1)-1);
%                 A_before = [NaN(1,abs(metMet(ii,1)-156)) A_before];
%                 signalMetMet_before(ii,:) = A_before;
%             else
%                 A_before= signal(roi,metMet(ii,1)-155:metMet(ii,1)-1);
%                 signalMetMet_before(ii,:) = A_before;
%             end
            A= signal(roi,metMet(ii,1):metMet(ii,1)+parameters.plottingWidth);
            signalMetMet(ii,:) = A;
            B=signal(roi,metMet(ii,2)-parameters.ITIWidth:metMet(ii,2));
            ITIsignalMetMet(ii,:)=B;
        end
        %         signalMetMet( ~any(signalMetMet,2), : ) = [];
        for ii=1:length(metBut)
%             if metBut(ii,1)-155 < 1
%                 A_before= signal(roi,1:metBut(ii,1)-1);
%                 A_before = [NaN(1,abs(metBut(ii,1)-156)) A_before];
%                 signalMetBut_before(ii,:) = A_before;
%             else
%                 A_before= signal(roi,metBut(ii,1)-155:metBut(ii,1)-1);
%                 signalMetBut_before(ii,:) = A_before;
%             end
            A= signal(roi,metBut(ii,1):metBut(ii,1)+parameters.plottingWidth);
            signalMetBut(ii,:) = A;
            B=signal(roi,metBut(ii,2)-parameters.ITIWidth:metBut(ii,2));
            ITIsignalMetBut(ii,:)=B;
        end
        
        %         signalMetBut(~any(signalMetBut,2), : ) = [];
%         oderAA_reponse   = [binTrials(signalButBut_before) binTrials(signalButBut) binTrials(ITIsignalButBut)];
%         oderAB_reponse   = [binTrials(signalButMet_before) binTrials(signalButMet) binTrials(ITIsignalButMet)];
% 
%         oderBB_reponse   = [binTrials(signalMetMet_before) binTrials(signalMetMet) binTrials(ITIsignalMetMet)];
%         oderBA_reponse   = [binTrials(signalMetBut_before) binTrials(signalMetBut) binTrials(ITIsignalMetBut)];
%     
        oderAA_reponse   = [ binTrials(signalButBut) binTrials(ITIsignalButBut)];
        oderAB_reponse   = [ binTrials(signalButMet) binTrials(ITIsignalButMet)];

        oderBB_reponse   = [ binTrials(signalMetMet) binTrials(ITIsignalMetMet)];
        oderBA_reponse   = [ binTrials(signalMetBut) binTrials(ITIsignalMetBut)];
    
end

% function binned = binTrials(trials)
% 
% for ii = 1:size(trials,1)
%     a=1;
%     for i= 1:3:(size(trials,2))
%         try
%             binned(ii,a)= sum(trials(ii,i:i+3)); %Bin into 250ms bins
%             a=a+1;
%         catch
%             binned(ii,a)= sum(trials(ii,i:end));
%             a=a+1;
%         end
%     end
%     
% end
% end


function binned = binTrials(trials)

% bin as discribed in taxidis paper (320 ms, for us its 323, and therefor 10 time bins) with 50% overlap

for ii = 1:size(trials,1)
    a=1;
    for i= 1:5:(size(trials,2))
        try
            binned(ii,a)= sum(trials(ii,i:i+10)); %Bin into 250ms bins
            a=a+1;
        catch
            binned(ii,a)= sum(trials(ii,i:end));
            a=a+1;
        end
    end
    
end
end
