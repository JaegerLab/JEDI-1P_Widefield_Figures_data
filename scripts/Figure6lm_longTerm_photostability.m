%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure6lm');
searchTerm = 'Figure6lm_early_late_traces_sensoryResponse.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure6lm', filesep);

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

%% Find and load matching file
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot')

figure
[lineOut, ~] = CIshade_methods(data2plot.earlySession_30Hz', 0.3, [0.8500 0.3250 0.0980], data2plot.IMG_x, [], '-');
lineOut.LineWidth = lineWidth;
hold on
[lineOut, ~] = CIshade_methods(data2plot.lateSession_30Hz', 0.3, 'k', data2plot.IMG_x, [], '-');
lineOut.LineWidth = lineWidth;
    
lineXs = 0:1/30:0.75;
for lineN = 1:length(lineXs)
    xline(lineXs(lineN), ':', 'Color', 'k', 'LineWidth', 0.3)
end

x_axis_txt_pos = [0.05, -0.1];
y_axis_txt_pos = [-0.1, 0.05];

shift_x = 0;


%plot scale bars for dff
plot([0; 0.1] + shift_x, [-0.2; -0.2], '-k', 'LineWidth', 0.75)
plot([0; 0] + shift_x, [-0.2; 0.3], '-k', 'LineWidth', 0.75)
%label scale bars
text(x_axis_txt_pos(1), x_axis_txt_pos(2), '0.1 s', 'HorizontalAlignment','center', 'FontSize', label_font)
text(y_axis_txt_pos(1), y_axis_txt_pos(2), {'0.5 %'}, 'HorizontalAlignment','center', 'FontSize', label_font)
label_x_pos = -0.05;

set(gca, 'Visible', 'off')

set(gcf,'units', 'centimeters', 'Position',[30,1,10.5,3]);
currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat(savePath, 'Figure6l_30Hz_6_mice_early_vs_late_mean_response_trace_', currentDate);
savefig(imgName)
saveas(gcf,imgName, 'jpg') 
saveas(gcf,imgName, 'pdf') 


figure
[lineOut, ~] = CIshade_methods(data2plot.earlySession_50Hz', 0.3, [0.4940 0.1840 0.5560], data2plot.IMG_x, [], '-');
lineOut.LineWidth = lineWidth;
hold on
[lineOut, ~] = CIshade_methods(data2plot.lateSession_50Hz', 0.3, 'k', data2plot.IMG_x, [], '-');
lineOut.LineWidth = lineWidth;

lineXs = 0:1/50:0.75;
for lineN = 1:length(lineXs)
    xline(lineXs(lineN), ':', 'Color', 'k', 'LineWidth', 0.3)
end

x_axis_txt_pos = [0.05, -0.1];
y_axis_txt_pos = [-0.1, 0.05];

shift_x = 0;
shift_y = 0;

%plot scale bars for dff
plot([0; 0.1] + shift_x, [-0.2; -0.2], '-k', 'LineWidth', 0.75)
plot([0; 0] + shift_x, [-0.2; 0.3], '-k', 'LineWidth', 0.75)
%label scale bars
text(x_axis_txt_pos(1), x_axis_txt_pos(2), '0.1 s', 'HorizontalAlignment','center', 'FontSize', label_font)
text(y_axis_txt_pos(1), y_axis_txt_pos(2), {'0.5 %'}, 'HorizontalAlignment','center', 'FontSize', label_font)
label_x_pos = -0.05;

set(gca, 'Visible', 'off')

set(gcf,'units', 'centimeters', 'Position',[50,1,10.5,3]);

imgName = strcat(savePath, 'Figure6m_51Hz_6_mice_early_vs_late_mean_response_trace_', currentDate);
savefig(imgName)
saveas(gcf,imgName, 'jpg') 
saveas(gcf,imgName, 'pdf')    