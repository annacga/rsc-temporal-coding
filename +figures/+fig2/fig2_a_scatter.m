 
firing_fields_A = [];
firing_fields_B = [];
firing_fields_A_2 = [];
firing_fields_B_2 = [];
for f = 1:length(data(1).sessionIDs)
    firing_fields_A = [firing_fields_A;mData(1,f).OdorA.field_location;mData(1,f).TimeA.field_location];
    firing_fields_B = [firing_fields_B;mData(1,f).OdorB.field_location;mData(1,f).TimeB.field_location];
    
    firing_fields_A_2 = [firing_fields_A_2;mData(1,f).OdorA.field_location_2;mData(1,f).TimeA.field_location_2];
    firing_fields_B_2 = [firing_fields_B_2;mData(1,f).OdorB.field_location_2;mData(1,f).TimeB.field_location_2];
end
    

figure()
col(1,:) =  [142 215 150]./255; % Odor Sequence A colour
col(2,:) =  [154 193 209]./255; % Odor Sequence B colour

scatter(firing_fields_A_2,firing_fields_A,'MarkerFaceColor',col(1,:),'MarkerEdgeColor','none')
hold on
scatter(firing_fields_B_2,firing_fields_B,'MarkerFaceColor',col(2,:),'MarkerEdgeColor','none')

figure()
scatter(firing_fields_A_2, firing_fields_A, 'MarkerFaceColor', col(1,:), 'MarkerEdgeColor', 'none')
hold on

mdl = fitlm(firing_fields_A_2(:), firing_fields_A(:));

% Get the fitted values
yfit = predict(mdl, firing_fields_A_2(:));

% Plot the fitted line with the darker color
hLine = plot(firing_fields_A_2, yfit, 'Color', col(1,:) * 0.6, 'LineWidth', 2);

scatter(firing_fields_B_2, firing_fields_B, 'MarkerFaceColor', col(2,:), 'MarkerEdgeColor', 'none')
hold on

mdl = fitlm(firing_fields_B_2(:), firing_fields_B(:));

% Get the fitted values
yfit = predict(mdl, firing_fields_B_2(:));

% Plot the fitted line with the darker color
hLine = plot(firing_fields_B_2, yfit, 'Color', col(2,:) * 0.6, 'LineWidth', 2);

% % Labels and title
xlabel('Firing field - inter-trial interval (s)')
ylabel('Firing field - delay time (s)')
yticks([0:31/5:39])
yticklabels([0:6])
xticks([0:31/5:69])
xticklabels([0:11])


% Colors
col(1,:) =  [142 215 150]./255; % Original color
dark_col = col(1,:) * 0.6; % Darker color (adjust the factor as needed)



% Initialize the co-occurrence matrix
coOccurrenceMatrix = zeros(38, 69);
vec1 = [firing_fields_A(:);firing_fields_B(:)];
vec2 = [firing_fields_A_2(:);firing_fields_B_2(:)];

% Populate the co-occurrence matrix
for i = 1:38
    idx = find(vec1 == i);
    for j = 1:length(unique(vec2))
        coOccurrenceMatrix(i,j) = length(find(vec2(idx) == j));
    end
end

% Display the co-occurrence matrix
figure;
imagesc(flipud(coOccurrenceMatrix));
colorbar;
xlabel('Vector 2 Values (1 to 69)');
ylabel('Vector 1 Values (1 to 38)');
title('Co-occurrence Matrix');

% Labels and title
xlabel('Firing field - inter-trial interval (s)')
ylabel('Firing field - delay time (s)')
yticks([1:31/5:39])
yticklabels([6 5 4 3 2 1 0])
xticks([1:31/5:69])
xticklabels([0:11])
xlim([0.5 40])
ylim([0 11])
h = colorbar;
h.Label.String = 'Occurence';

mdl = fitlm([firing_fields_A_2(firing_fields_A_2<38);firing_fields_B_2(firing_fields_B_2<38)], [firing_fields_A(firing_fields_A_2<38);firing_fields_B(firing_fields_B_2<38)]);

% Get the fitted values
yfit = predict(mdl,[firing_fields_A_2(firing_fields_A_2<38);firing_fields_B_2(firing_fields_B_2<38)]);




hold on
% Plot the fitted line with the darker color
hLine = plot([firing_fields_A_2(firing_fields_A_2<38);firing_fields_B_2(firing_fields_B_2<38)], yfit, 'Color', col(1,:) * 0.6, 'LineWidth', 2);

% Plot the co-occurrence matrix with imagesc
figure;
imagesc(flipud(coOccurrenceMatrix));
colorbar;

% Set labels, title, and axis limits as before
xlabel('Firing field - inter-trial interval (s)');
ylabel('Firing field - delay time (s)');
title('Co-occurrence Matrix');

% Custom ticks
%yticks(linspace(1, size(coOccurrenceMatrix, 1), 6));
%yticklabels([6 5 4 3 2 1 0]);
%xticks(linspace(1, size(coOccurrenceMatrix, 2), 12));
%xticklabels(0:11);
%xlim([0.5, size(coOccurrenceMatrix, 2) + 0.5]);

% Configure the colorbar label
h = colorbar;
h.Label.String = 'Occurrence';

% Fit the model
mdl = fitlm([firing_fields_A_2(:); firing_fields_B_2(:)], [firing_fields_A(:); firing_fields_B(:)]);

% Predict values for fitted line
yfit = predict(mdl, [firing_fields_A_2(:); firing_fields_B_2(:)]);

% Adjust the scaling of the fitted line to match matrix coordinates
%x_firing_scaled = rescale([firing_fields_A_2(:); firing_fields_B_2(:)], 0.5, size(coOccurrenceMatrix, 2) + 0.5);
%yfit_scaled = rescale(yfit, 0.5, size(coOccurrenceMatrix, 1) + 0.5);
figure()
% Overlay the fitted line
hold on;
plot([firing_fields_A_2(:); firing_fields_B_2(:)], yfit, 'Color', [0,0,0], 'LineWidth', 2);
hold off;



% Scatter plot with transparency and smaller markers
figure()
scatter(firing_fields_A_2, firing_fields_A, 40, 'MarkerFaceColor', col(1,:), 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.6)
hold on
scatter(firing_fields_B_2, firing_fields_B, 40, 'MarkerFaceColor', col(2,:), 'MarkerEdgeColor', 'none', 'MarkerFaceAlpha', 0.6)

% Get the fitted values
p = polyfit([firing_fields_A_2(:);firing_fields_B_2(:)], [firing_fields_A(:);firing_fields_B(:)], 2); % 2nd degree polynomial fit

% Add a grid
grid on

% Labels and title
xlabel('Firing field - inter-trial interval (s)')
ylabel('Firing field - delay time (s)')
title('Scatter plot with linear fit')
set(gca,'FontSize',12)

hold off

