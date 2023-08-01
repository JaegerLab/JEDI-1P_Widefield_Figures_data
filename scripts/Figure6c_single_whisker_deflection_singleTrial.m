%% Plot Figure 6c

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure6c');
searchTerm = 'Figure6c_EMXJ30_contraBarrel_singleWhiskerResponse.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure6c', filesep);

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

%% Plot
figure

plot(data2plot.img_x, reshape(data2plot.img_y, [1200, 1]), 'LineWidth', 0.6)
hold on
set(gca, 'box', 'off')
set(gca, 'LineWidth', 1)
xline(0, 'r--')
xline(1, 'r--')
xline(2, 'r--')
xline(3, 'r--')
xline(4, 'r--')
xlim([-1, 2.5])
xlabel('Time (s)')
ylabel('- \DeltaF/F %')

currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat(savePath, 'Figure6c_single_whisker_deflection_', currentDate);
set(gcf, 'Units', 'Centimeters', 'Position', [1, 1, 4.5, 4.5]);
savefig(imgName)
saveas(gcf, imgName, 'pdf')
saveas(gcf,imgName, 'png')

