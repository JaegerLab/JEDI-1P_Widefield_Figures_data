%% Figure 3de Plot Raw Light Readout of Multiple Animals
%Animal list
%EMXJ 3, 4, 7, 8, 9, 10, 11, 12, 13, 15

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
datafFilePath = strcat(filePath, filesep, 'data', filesep, 'Figure3de');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure3de', filesep);
searchTermExp = 'EMXJ*RawF.mat'; % Name of the file to generate the figure
searchTermCtrl = 'Ctrl*RawF.mat';


%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end
%% Set font size
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.3;

z = 1.96; % 95% CI

transparencyValue = 0.5; %transparency of line plot
shiftPlotX = 0.14; %shift line plot based on bar plot location
%% Find the list of files to load (experimental group and control group) 
fileListsExp = dir(fullfile(datafFilePath, '**', searchTermExp));
fileListsCtrl = dir(fullfile(datafFilePath, '**', searchTermCtrl));
%% Pre-allocate the data
metaList_RawF_exp = struct('ROI1_green', cell(1, length(fileListsExp)));
rawF_green_sum_exp = zeros(length(fileListsExp), 6); % 6 ROIs from 10 trials
rawF_red_sum_exp = zeros(length(fileListsExp), 6); % 6 ROIs from 10 trials

%% Plot green channel light intensity from each mouse
c_g = summer(12);
c_r = gray(12);
for fileN = 1:length(fileListsExp)
    %register file folder and file name for each metalis
    fileFolder = fileListsExp(fileN).folder;
    fileName = fileListsExp(fileN).name;
    %generate full filepath for the file of interest
    fullFN = strcat(fileFolder, '\', fileName);
    
    %load the folder and remove the RawF structure
    fileInfo = load(fullFN);
    RawF = fileInfo.RawF;
    
    %scale the mean rawF and reorder the ROIs
    newOrder = [1, 3, 5, 2, 4, 6]; % reorder so ROIs 1, 3, 5 are from the same hemisphere; 2,4,6 are from the same hemisphere.
    rawF_green = [RawF.green.ROI.meanRawF]/1000;
    rawF_green = rawF_green(newOrder);

    rawF_red = [RawF.red.ROI.meanRawF]/1000;
    rawF_red = rawF_red(newOrder);

    for ROI_N = 1:length(RawF.green.ROI)
        ROI_N_str = strcat('ROI', string(ROI_N));
        ROI_N_str_green = strcat(ROI_N_str, '_green');
        ROI_N_str_red = strcat(ROI_N_str, '_red');
        metaList_RawF_exp(fileN).(ROI_N_str_green) = rawF_green(ROI_N);
        metaList_RawF_exp(fileN).(ROI_N_str_red) = rawF_red(ROI_N);
    end
    rawF_green_sum_exp(fileN, :) = rawF_green;
    rawF_red_sum_exp(fileN, :) = rawF_red;

    % Plot the raw intensity from each animal
    x = [1, 2, 3, 4, 5, 6];
    figure(1)
    line1 = plot(x -  shiftPlotX, rawF_green, '-', 'LineWidth', lineWidth, 'color', c_g(fileN, :), 'HandleVisibility','off');
    hold on
    line1.Color(4) = transparencyValue;


    figure(2)
    line2 = plot(x -  shiftPlotX, rawF_red, '-', 'LineWidth', lineWidth, 'color', c_r(fileN, :), 'HandleVisibility','off');
    line2.Color(4) = transparencyValue;
    hold on    
end

%% Define Paths of Loading Files and Save Files of Control Mice
metaList_RawF_ctrl = struct('ROI1_green', cell(1, length(fileListsCtrl)));
rawF_green_sum_ctrl = zeros(length(fileListsCtrl), 6); % 6 ROIs from 10 trials
rawF_red_sum_ctrl = zeros(length(fileListsCtrl), 6); % 6 ROIs from 10 trials

%% Plot green channel light intensity from each control mouse
ctrl_g = bone(6);
ctrl_r = bone(6);
for fileN = 1:length(fileListsCtrl)
    %register file folder and file name for each metalis
    fileFolder = fileListsCtrl(fileN).folder;
    fileName = fileListsCtrl(fileN).name;
    %generate full filepath for the file of interest
    fullFN = strcat(fileFolder, '\', fileName);
    
    %load the folder and remove the RawF structure
    fileInfo = load(fullFN);
    RawF = fileInfo.RawF;
    
    %scale the mean rawF and reorder the ROIs
    newOrder = [1, 3, 5, 2, 4, 6];
    rawF_green = [RawF.green.ROI.meanRawF]/1000;
    rawF_green = rawF_green(newOrder);

    rawF_red = [RawF.red.ROI.meanRawF]/1000;
    rawF_red = rawF_red(newOrder);

    for ROI_N = 1:length(RawF.green.ROI)
        ROI_N_str = strcat('ROI', string(ROI_N));
        ROI_N_str_green = strcat(ROI_N_str, '_green');
        ROI_N_str_red = strcat(ROI_N_str, '_red');
        metaList_RawF_ctrl(fileN).(ROI_N_str_green) = rawF_green(ROI_N);
        metaList_RawF_ctrl(fileN).(ROI_N_str_red) = rawF_red(ROI_N);
        
    end
    rawF_green_sum_ctrl(fileN, :) = rawF_green;
    rawF_red_sum_ctrl(fileN, :) = rawF_red;    
    figure(1)
    line1 = plot(x +  shiftPlotX, rawF_green, ':', 'LineWidth', lineWidth, 'color', ctrl_g(fileN, :), 'HandleVisibility','off');
%     line1.Color(4) = transparencyValue;
    hold on
    
    figure(2)
    line2 = plot(x +  shiftPlotX, rawF_red, ':', 'LineWidth', lineWidth, 'color', ctrl_r(fileN, :), 'HandleVisibility','off');
%     line2.Color(4) = transparencyValue;
    hold on    
    
end

% Calculate mean of all mice (JEDI-1P and control)

meanRawF_green_exp = mean(rawF_green_sum_exp, 1)';
meanRawF_red_exp = mean(rawF_red_sum_exp, 1)';

meanRawF_green_ctrl = mean(rawF_green_sum_ctrl, 1)';
meanRawF_red_ctrl = mean(rawF_red_sum_ctrl, 1)';

%sampleSize 
arraySize = size(rawF_green_sum_exp);
sampleSize_JEDI = arraySize(1);

arraySize = size(rawF_green_sum_ctrl);
sampleSize_ctrl = arraySize(1);

%% Calculate standard error
standard_error_JEDI_green = z * std(rawF_green_sum_exp, 0, 1)/sqrt(sampleSize_JEDI);
standard_error_JEDI_red = z * std(rawF_red_sum_exp, 0, 1)/sqrt(sampleSize_JEDI);

standard_error_ctrl_green = z * std(rawF_green_sum_ctrl, 0, 1)/sqrt(sampleSize_ctrl);
standard_error_ctrl_red = z * std(rawF_red_sum_ctrl, 0, 1)/sqrt(sampleSize_ctrl);

% m groups X n bars
meanBarGreen = [meanRawF_green_exp, meanRawF_green_ctrl, ];
meanBarRed = [meanRawF_red_exp, meanRawF_red_ctrl, ];

% ensure that the error bar is the same size as the meanBarGreen
group_errorBar_green = [standard_error_JEDI_green; standard_error_ctrl_green]';
group_errorBar_red = [standard_error_JEDI_red; standard_error_ctrl_red]';

legend_y1 = 0.93 * 7;
legend_y2 = 0.85 * 7;

legend_x = [2.3, 2.7];

figure(1)
plot(legend_x, [legend_y1, legend_y1], '-', 'LineWidth', lineWidth, 'color', c_g(fileN, :), 'HandleVisibility','off');
plot(legend_x, [legend_y2, legend_y2], ':', 'LineWidth', lineWidth, 'color', ctrl_g(fileN, :), 'HandleVisibility','off');

legend_y1 = 0.93 * 4.1;
legend_y2 = 0.85 * 4.1;

figure(2)
plot(legend_x, [legend_y1, legend_y1], '-', 'LineWidth', lineWidth, 'color', c_r(fileN, :), 'HandleVisibility','off')
plot(legend_x, [legend_y2, legend_y2], ':', 'LineWidth', lineWidth, 'color', ctrl_r(fileN, :), 'HandleVisibility','off')


figure(1) 
b1 = bar(1:6, meanBarGreen, 1, 'grouped');
b1(1).FaceColor = [9, 112, 84]/256;
b1(2).FaceColor = [0.5 0.5 0.5];
b1(1).EdgeColor = 'none';
b1(2).EdgeColor = 'none';


xlim([0 6.5])
ylim([0 7])

[hleg1, hobj1] = legend('JEDI-1P-Kv', 'Control', ...
    'FontSize',legend_font, 'Location', 'northwest');
legend boxoff

% Calculate the number of groups and number of bars in each group
[ngroups, nbars] = size(meanBarGreen);
b1(1).EdgeColor = 'none';
b1(2).EdgeColor = 'none';
% Get the x coordinate of the bars
x_green = nan(ngroups, nbars);
for i = 1:nbars
    x_green(:,i) = b1(i).XEndPoints;
end
% Plot the errorbars
errorbar(x_green,meanBarGreen,[], group_errorBar_green,'k', 'LineWidth', 0.7, 'linestyle','none');

% title('JEDI-1P Channel', 'FontSize', title_font)

xticks([1 2 3 4 5 6])
ax = gca;
ax.FontSize = axis_font; 
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
set(gca,'YTick', 0:2:8, 'linewidth',1)
xticklabels({'1', '2', '3', '4', '5', '6'})
xlabel('Regions of interst (ROIs) #', 'FontSize', label_font)
ylabel('Mean intensity (arb.unit)', 'FontSize', label_font)
set(gca,'box','off')
set(gcf,'units', 'centimeters', 'Position',[10,1,4.5,4.5]);
% set(gcf,'units', 'centimeters', 'Position',[10,1,6,4.2]);

currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
fileName = 'Figure3d_Green_JEDI_channel_exp_ctrl_comparison';
imgName = strcat(savePath, filesep, fileName, '_', currentDate);

savefig(imgName)
saveas(gcf,imgName, 'png') 
saveas(gcf,imgName, 'pdf') 


figure(2)
b2 = bar(1:6, meanBarRed, 1);
b2(1).FaceColor = [0,0,0];
b2(2).FaceColor = [0.5 0.5 0.5];
b2(1).EdgeColor = 'none';
b2(2).EdgeColor = 'none';

legend boxoff
% Calculate the number of groups and number of bars in each group
[ngroups, nbars]= size(meanBarRed);
b2(1).EdgeColor = 'none';
b2(2).EdgeColor = 'none';
% Get the x coordinate of the bars
x_red = nan(ngroups, nbars);
for i = 1:nbars
    x_red(:, i) = b2(i).XEndPoints;
end
% Plot the errorbars
errorbar(x_red,meanBarRed,[], group_errorBar_red,'k', 'LineWidth', 0.7, 'linestyle','none');

xlim([0 6.5])
ylim([0 4.1])
legend('mCherry', 'Control', ...
    'FontSize',legend_font, 'Location', 'northwest')
% title('Reference Channel', 'FontSize', title_font)
xticks([1 2 3 4 5 6])
ax = gca;
ax.FontSize = axis_font; 
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
set(gca, 'linewidth',1)
xticklabels({'1', '2', '3', '4', '5', '6'})
xlabel('ROIs #', 'FontSize', label_font)
ylabel('Mean intensity (arb.unit)', 'FontSize', label_font)
set(gca,'box','off')
set(gcf,'units', 'centimeters', 'Position',[10,1,4.5,4.5]);

currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
fileName = 'Figure3d_Red_reference_channel_exp_ctrl_comparison';
imgName = strcat(savePath, filesep, fileName, '_', currentDate);

savefig(imgName)
saveas(gcf,imgName, 'png') 
saveas(gcf,imgName, 'pdf') 

%% Two-sided Mann Whitney U test of the same ROIs

p_ROI_g = zeros(1, size(rawF_green_sum_exp, 2));
p_ROI_r = zeros(1, size(rawF_red_sum_exp, 2));
for ROI_N = 1:length(newOrder)
    p_ROI_g(ROI_N) = ranksum(rawF_green_sum_exp(:, ROI_N), rawF_green_sum_ctrl(:, ROI_N));
    p_ROI_r(ROI_N) = ranksum(rawF_red_sum_exp(:, ROI_N), rawF_red_sum_ctrl(:, ROI_N));
end
