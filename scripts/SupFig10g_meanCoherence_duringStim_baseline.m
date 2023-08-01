%% Plot Supplementary Figure 10c f from loaded data

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure10g');
searchTerm = 'SupFigure10g_meanCoherence_diffFreqs_baseline.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure10g', filesep);

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

%% Load mask
maskImg = imread(strcat(searchPath, filesep, 'Masking_standard.png'));
mask = maskImg(:, :, 1);
mask = imresize(mask, [50, 50], 'nearest');
mask = mask == 255;

%% Find and load matching file
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot')
coherence_2D_all = data2plot;
%% Plot the figure

figure
subplot(1, 6, 1)
meanCoherence = coherence_2D_all(:, :, 6);
meanCoherence(mask) = 0;
imshow(meanCoherence, [0, 0.3])
title('Baseline 25 Hz')
for stimN = 1:5
    if stimN == 1
        freqOfInterest = 25;
    else
        freqOfInterest = 10 * (stimN + 1);
    end
    subplot(1, 6, stimN + 1)
    meanCoherence = mean(coherence_2D_all(:, :, stimN, :), 4);
    meanCoherence(mask) = 0;
    imshow(meanCoherence, [0, 0.3])
    title(strcat("Freq ", string(freqOfInterest)))
    
    if stimN == 5
       cb=colorbar;
%        cb.Position = [cbPosition(1) + 0.07, cbPosition(2)-0.05, cbPosition(3) *2, cbPosition(4)*3];
    end
end

colormap('Turbo')
set(gcf, 'Position', [1, 10, 600, 125])
cb.Position = [cb.Position(1) + 0.07, cb.Position(2)-0.25, cb.Position(3) *2, cb.Position(4)*3];
imgFN = strcat(savePath, 'SupFigure10g_mean_coherence_stimOn_20230628');
savefig(imgFN) 
saveas(gcf, imgFN, 'jpg')
saveas(gcf, imgFN, 'pdf') 
close all
