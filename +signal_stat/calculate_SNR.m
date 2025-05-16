

function SNR  = calculate_SNR(sData)

     % peakSNR=Δpeak/ 2*σn
     % Δpeak is the difference between the biggest spike value 
     % and σn is the noise SD calculated from nonactive intervals of traces.
    DFF = sData.imData.roiSignals.dff;
    [noROIs,noSample] = size(DFF);
    
    % Low-pass filter fluorescence signals to find noise and actual signal
    
    DFF_lowpass = NaN(noROIs,noSample);
    
%     % check frequency distribution of single cells: 
%     roiNO = 10;
%     s  = DFF(roiNO,:);
%     L = length(s);                                      % Vector Length
%     Ts = 1/31;                                          % Sampling Interval (sec)
%     Fs = 1/Ts;                                          % Sampling Frequency (Hz)
%     Fn = Fs/2;                                          % Nyquist Frequency (Hz)
%     t = 1:Ts:L*Ts;                                      % Time Vector
%     FTs = fft(s-mean(s))/L;                             % Fourier Transform (Subtract d-c Offset)
%     Fv = linspace(0, 1, fix(L/2)+1)*Fn;                 % Frequency Vector
%     Iv = 1:length(Fv);                                  % Index Vector
% 
%     figure()
%     plot(Fv, abs(FTs(:,Iv))*2)
%     hold on
%     hold off
%     grid
%     axis([0 1 ylim])
%     
%     
    % filter paramters:
    
    fpass = 0.1;
    fs    = 31;
    for i = 1:noROIs
        if ~isnan(sum(double(DFF(i,:))))
            DFF_lowpass(i,:) = lowpass(double(DFF(i,:)),fpass,fs);% filter(Hd,DFF(i,:)); 
           
        else
            DFF_lowpass(i,:) = NaN(1,size(DFF,2));
        end
       
    end
    noise = DFF - DFF_lowpass;  % subtract the lowpassed data from baseline-corrected signal to get the noise
    
    
    
%   check noise, DFF and DFF_lowpasse:
%     figure()
%     plot(noise(roiNO,:))
%     hold on
%     plot(DFF(roiNO,:))
%     plot(DFF_lowpass(roiNO,:),'k')
   

    % calculate SNR 
    noiseStd = NaN(noROIs,1); % whole session std for each ROI
    ROIPeak  = NaN(noROIs,1); % the highest peaks in that ROI 
    SNR      = NaN(noROIs,1); % signal to noise ratio for each ROI
    for i = 1:noROIs
        noiseStd(i) = 2*std(noise(i,:),[],2); % can be adjusted to 1*std(PreNoise(i,:),[],2);
        ROIPeak(i)  = prctile(DFF(i,:),99); % can be adjusted to 95%
        SNR(i)      = ROIPeak(i) / noiseStd(i);
    end
end

