%% Plot Figure 6e and 6i from loaded data

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure6ei');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure6ei', filesep);

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
plotMeanPowerSpatialMap("AP", "40", searchPath, savePath)
plotMeanPowerSpatialMap("AP", "60", searchPath, savePath)
plotMeanPowerSpatialMap("Flicker", "40", searchPath, savePath)
plotMeanPowerSpatialMap("Flicker", "60", searchPath, savePath)
%% Function used for plotting
function plotMeanPowerSpatialMap(experimentType, selectedFrequency, searchPath, savePath)

switch experimentType
    case "AP"
        searchTerm = 'Figure6i_AP_meanPowerAt40or60Hz_maskedSpatialMap.mat';
        filePrefix = 'Figure6i_AP_';
        scaleMinMax = [-2, 11];
    case "Flicker"
        searchTerm = 'Figure6e_Flicker_meanPowerAt40or60Hz_maskedSpatialMap.mat';
        filePrefix = 'Figure6e_Flicker_';
        scaleMinMax = [-2, 14];
end

%% Find and load matching file
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'meanPower')

%% Select struct to plot
fieldString = strcat('Freq', selectedFrequency, 'Hz');
meanPowerDiff = meanPower.(fieldString);

%% Plot spatial map of power difference
figure
imshow(meanPowerDiff, scaleMinMax);
colormap('viridis')
c = colorbar;
c.Label.String = 'Power difference (dB)';
c.Label.FontSize = 7;
c.Label.FontName = 'Arial';
c.FontSize = 7;
set(gcf,'units', 'centimeters', 'Position',[30,1,12,9]);
currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgSaveName = strcat(savePath, filePrefix, 'allMice_', experimentType,'_meanPowerAt', selectedFrequency, 'Hz_', currentDate);

savefig(imgSaveName)
saveas(gca, imgSaveName, 'pdf')
saveas(gca, imgSaveName, 'png')
close all
end