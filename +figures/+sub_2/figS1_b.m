clear all
dirc = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/PROCESSED/PID/day1';
dirct = '/Users/annachristinagarvert/UIO Physiology Dropbox Dropbox/Lab Data/Malte Bieler/RAWDATA/PID/FINAL/PID_20190227_finalCorrectOdor/';

%% PID MEASUREMENTS
experiment.IDPID = 'PID_20190227_finalCorrectOdorDAQdata_matlab_compatible';
experiment.IDodor  = 'PID_20190227_finalCorrectOdorPIDdata_matlab_compatible';

f = 14;
    
% Load PID and odor file and assign values
fileName = [dirct,experiment.IDodor,'.tdms'];
matFileName=simpleConvertTDMS(fileName,0);
A= load(matFileName{1});
PIDSignal=A.PID_20190227_finalCorrectOdorDev1ai0.Data';

fileName = [dirct,'/','/',experiment.IDPID,'.tdms'];
matFileName=simpleConvertTDMS(fileName,0);
DAQvariables=load(matFileName{1});
 
OdorOne=DAQvariables.PID_20190227_finalCorrectOdorovalve1Dev1port0line1.Data;
OdorTwo=DAQvariables.PID_20190227_finalCorrectOdorovalve2Dev1port0line2.Data;
B=PIDSignal(1:9400000)';
C=min(B);
D=B-C;
E = D;

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
odorTwoTimes=odorTwoTimes';
odorsSecond=sort(horzcat(odorOneTimes, odorTwoTimes));
[temp, order] = sort(odorsSecond(2,:));
odorsSecond = odorsSecond(:,order);
odors(:,2)=odorsSecond(2,:);
odors(:,4)=odorsSecond(1,:);

cc=1;
n=0;
for b=1:(length(odors)/2)
    n=n+1;
    trials(n,1)=odors(cc,1); %Select every thrid value to get onset of trial
    cc= cc+2;
end
clear A
clear B

%        PIDSignalProcessed=smooth(abs(PIDSignal-max(PIDSignal)),250)';
PIDSignalProcessed=E;
a=0;
for ii = 1:(size(odors,1)/2)
    %         try
    if odors(ii,3)==1
        if odors (ii+1,3)==1
            try
                a=a+1;
                matchedA{a,1}=PIDSignalProcessed(trials(ii,1):trials(ii+1,1));
            catch
                a=a+1;
                matchedA{a,1}=PIDSignalProcessed(trials(ii,1):end);
            end
        else
            try
                a=a+1;
                nonmatchedA{a,1}=PIDSignalProcessed(trials(ii,1):trials(ii+1,1));
            catch
                a=a+1;
                nonmatchedA{a,1}=PIDSignalProcessed(trials(ii,1):end);
            end
        end
    end
    if odors(ii,3)==2
        if odors (ii+1,3)==2
            try
                a=a+1;
                matchedB{a,1}=PIDSignalProcessed(trials(ii,1):trials(ii+1,1));
            catch
                a=a+1;
                matchedB{a,1}=PIDSignalProcessed(trials(ii,1):end);
            end
        else
            try
                a=a+1;
                nonmatchedB{a,1}=PIDSignalProcessed(trials(ii,1):trials(ii+1,1));
            catch
                a=a+1;
                nonmatchedB{a,1}=PIDSignalProcessed(trials(ii,1):end);
            end
        end
    end
    
    %         end
end

fullMatchedA = matchedA(~cellfun('isempty', matchedA));
maxLengthCell=max(cellfun('size',fullMatchedA,2));  %finding the longest vector in the cell array
for i=1:length(fullMatchedA)
    for j=cellfun('size',fullMatchedA(i),2)+1:maxLengthCell
        fullMatchedA{i}(j)=0;   %zeropad the elements in each cell array with a length shorter than the maxlength
    end
end
mergedFullMatchedA=cell2mat(fullMatchedA); %A is your matrix
firstMergedFullMatchedA=mean(mergedFullMatchedA(1:(size(mergedFullMatchedA,1))/2,:));
secondMergedFullMatchedA=mean(mergedFullMatchedA((size(mergedFullMatchedA,1))/2:end,:));


fullMatchedB = matchedB(~cellfun('isempty', matchedB));
maxLengthCell=max(cellfun('size',fullMatchedB,2));  %finding the longest vector in the cell array
for i=1:length(fullMatchedB)
    for j=cellfun('size',fullMatchedB(i),2)+1:maxLengthCell
        fullMatchedB{i}(j)=0;   %zeropad the elements in each cell array with a length shorter than the maxlength
    end
end
mergedFullMatchedB=cell2mat(fullMatchedB); %A is your matrix
firstMergedFullMatchedB=mean(mergedFullMatchedB(1:(size(mergedFullMatchedB,1))/2,:));
secondMergedFullMatchedB=mean(mergedFullMatchedB((size(mergedFullMatchedB,1))/2:end,:));

fullnonMatchedA = nonmatchedA(~cellfun('isempty', nonmatchedA));
maxLengthCell=max(cellfun('size',fullnonMatchedA,2));  %finding the longest vector in the cell array
for i=1:length(fullnonMatchedA)
    for j=cellfun('size',fullnonMatchedA(i),2)+1:maxLengthCell
        fullnonMatchedA{i}(j)=0;   %zeropad the elements in each cell array with a length shorter than the maxlength
    end
end
mergedFullnonMatchedA=cell2mat(fullnonMatchedA); %A is your matrix
firstnonMergedFullMatchedA=mean(mergedFullnonMatchedA(1:(size(mergedFullnonMatchedA,1))/2,:));
secondnonMergedFullMatchedA=mean(mergedFullnonMatchedA((size(mergedFullnonMatchedA,1))/2:end,:));

fullnonMatchedB = nonmatchedB(~cellfun('isempty', nonmatchedB));
maxLengthCell=max(cellfun('size',fullnonMatchedB,2));  %finding the longest vector in the cell array
for i=1:length(fullnonMatchedB)
    for j=cellfun('size',fullnonMatchedB(i),2)+1:maxLengthCell
        fullnonMatchedB{i}(j)=0;   %zeropad the elements in each cell array with a length shorter than the maxlength
    end
end
mergedFullnonMatchedB=cell2mat(fullnonMatchedB); %A is your matrix
firstnonMergedFullMatchedB=mean(mergedFullnonMatchedB(1:(size(mergedFullnonMatchedB,1))/2,:));
secondnonMergedFullMatchedB=mean(mergedFullnonMatchedB((size(mergedFullnonMatchedB,1))/2:end,:));


a=0;
for ii=1:size(odors,1)
    a=a+1;
    if odors(ii,3)==2
        odorTwo(a,1:2)=odors(ii,1:2);
    else
        a=a+1;
        odorOne(a,1:2)=odors(ii,1:2);
    end
end
odorTwo = odorTwo(any(odorTwo,2),:);
odorOne = odorOne(any(odorOne,2),:);
for ii = 1:size(odorTwo,1)
    odorTwoPID{ii,:}=PIDSignalProcessed(odorTwo(ii,1):(odorTwo(ii,2)+10000));
end
for ii = 1:size(odorOne,1)
    odorOnePID{ii,:}=PIDSignalProcessed(odorOne(ii,1):(odorOne(ii,2)+10000));
end

maxlength = max(cellfun(@(x) length(x),odorTwoPID));

for ii = 1:size(odorTwoPID,1)
    A=odorTwoPID{ii};
    B=[A' zeros(1,maxlength-length(A))];
    odorTWO(ii,:)=B;
end
for ii = 1:size(odorOnePID,1)
    A=odorOnePID{ii};
    B=[A' zeros(1,maxlength-length(A))];
    odorONE(ii,:)=B;
end

figure
plot([1:length(mean(odorTWO))]./2000,mean(odorTWO),'LineWidth',3)
hold on
plot([1:length(mean(odorONE))]./2000,mean(odorONE),'LineWidth',3)
legend('Butanol', 'Methyl')
hold on
line([1 1],[-2 1],'Color','k')
hold on
line([6 6],[-2 1],'Color','k')
hold on
line([7 7],[-2 1],'Color','k')
ylabel('PID voltage (v)')
ylim([0 1])
xticklabels([0:7])
set(gca,'FontName','Arial','FontSize',15)
box off
xlabel('Time (s)')


butanol = mean(odorTWO); 
butanol(1:2000)=[];
methyl  = mean(odorONE);
methyl(1:2000)=[];
xData   = [1:length(butanol)]./2000;

tbl = table(xData(:), butanol(:));
modelfun = @(b,x) b(1) * exp(b(2)*x(:, 1))+b(3);  
%modelfun = @(b,x) 0.32 * exp(b(1)*x(:, 1))+b(2);  

beta0 = [0.5 -0.01 0.02]; % Guess values to start with.  Just make your best guess.
% Now the next line is where the actual model computation is done.
mdl = fitnlm(tbl, modelfun,beta0);
coefficients = mdl.Coefficients{:, 'Estimate'}
yFitted = coefficients(1) * exp(coefficients(2)*xData)+coefficients(3);
% Now we're done and we can plot the smooth model as a red line going through the noisy blue markers.
hold on;
plot(xData+1, yFitted, 'b--', 'LineWidth', 2);
fprintf('The decay time constant for odor A is: %4.2f s\n',1/abs(coefficients(2)))


tbl = table(xData(:), methyl(:));
modelfun = @(b,x) b(1) * exp(b(2)*x(:, 1))+b(3);  

beta0 = [0.1 -0.01 0.02]; % Guess values to start with.  Just make your best guess.
mdl = fitnlm(tbl, modelfun,beta0);
coefficients = mdl.Coefficients{:, 'Estimate'};
yFitted = coefficients(1) * exp(coefficients(2)*xData)+coefficients(3);
hold on;
plot(xData+1, yFitted, 'r--', 'LineWidth', 2);
fprintf('The decay time constant for odor B is: %4.2f s\n',1/abs(coefficients(2)))

legend('off')
