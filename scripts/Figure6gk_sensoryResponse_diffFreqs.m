%% Plot Figure 6g and 6k

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure6gk');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure6gk', filesep);

%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end
%% Set up parameters for plotting
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.5;
scale_font = 5;

%% Plot
plotMeanPowerSpatialMap("AP", searchPath, savePath)
plotMeanPowerSpatialMap("Flicker", searchPath, savePath)
%% Function used for plotting
function plotMeanPowerSpatialMap(experimentType, searchPath, savePath)

switch experimentType
    case "AP"
        searchTerm = 'Figure6k_AP_mean_ROI_trace_diffFreqs.mat';
        firstLabel = '25 Hz';
        filePrefix = 'Figure6k_AP_';
    case "Flicker"
        searchTerm = 'Figure6g_Flicker_mean_ROI_trace_diffFreqs.mat';
        firstLabel = '20 Hz';
        filePrefix = 'Figure6g_Flicker_';
end

%% Find and load matching file
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot')

%% Plot spatial map of power difference
shiftY = data2plot.shiftY;
label_font = 7;
figure
plot(data2plot.IMG_x, data2plot.traces_freq1 + shiftY, 'LineWidth', 1)
hold on
plot(data2plot.IMG_x, data2plot.traces_freq2 + shiftY * 2, 'LineWidth', 1)

plot(data2plot.IMG_x, data2plot.traces_freq3 + shiftY * 3, 'LineWidth', 1)

plot(data2plot.IMG_x, data2plot.traces_freq4 + shiftY * 4, 'LineWidth', 1)

plot(data2plot.IMG_x, data2plot.traces_freq5 + shiftY * 5, 'LineWidth', 1)



x_axis_txt_pos = [0.05, -0.1];
y_axis_txt_pos = [-0.1, 0.05];

shift_x = 0;

%plot scale bars for dff
plot([0; 0.1] + shift_x, [-0.2; -0.2], '-k', 'LineWidth', 0.75)
plot([0; 0] + shift_x, [-0.2; 0], '-k', 'LineWidth', 0.75)
%label scale bars
text(x_axis_txt_pos(1), x_axis_txt_pos(2), '0.1 s', 'HorizontalAlignment','center', 'FontSize', label_font)
text(y_axis_txt_pos(1), y_axis_txt_pos(2), {'0.2 %', 'dF/F'}, 'HorizontalAlignment','center', 'FontSize', label_font)
label_x_pos = -0.05;

%label traces
text(label_x_pos , shiftY, firstLabel, 'HorizontalAlignment','center', 'fontweight','bold', 'FontSize', label_font)
text(label_x_pos, shiftY * 2, '30 Hz', 'HorizontalAlignment','center', 'fontweight','bold','FontSize', label_font)
text(label_x_pos, shiftY * 3, '40 Hz', 'HorizontalAlignment','center', 'fontweight','bold','FontSize', label_font)
text(label_x_pos, shiftY * 4, '50 Hz', 'HorizontalAlignment','center', 'fontweight','bold','FontSize', label_font)
text(label_x_pos, shiftY * 5, '60 Hz', 'HorizontalAlignment','center', 'fontweight','bold','FontSize', label_font)


set(gca, 'Visible', 'off')
set(gcf, 'units', 'centimeters', 'Position',[30,1,4.5, 6]);
currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat(savePath, filePrefix, experimentType, 'mean_ROI_trace_diff_freq_1p5-2s_', currentDate);

savefig(imgName)
saveas(gcf,imgName, 'png')
saveas(gcf,imgName, 'pdf')
end