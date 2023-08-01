%% Plot Supplementary Figure 9

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure9');
searchTerm = 'SupFig11_EMXJ*_SingleWhisker_allDeflections_eventAligned_shifted.mat';
searchTermMask = 'Masking_standard.png';
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure9', filesep);

%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end

%% Search for mask and load mask
maskFile = dir(fullfile(searchPath, '**', searchTermMask));
maskFN = strcat(maskFile.folder, filesep, maskFile.name);
maskImg = imread(maskFN);
maskImg = imresize(maskImg(:, :, 3), [50, 50], 'nearest');
mask = maskImg ~= 0;

%% Load data
matchingFile = dir(fullfile(searchPath, '**', '*ascend*'));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'plotArrays')
plotSpatialMaps(plotArrays, savePath, mask, "ascend")

matchingFile = dir(fullfile(searchPath, '**', '*descend*'));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'plotArrays')
plotSpatialMaps(plotArrays, savePath, mask, "descend")
%% Plot spatial maps of 12 frames around the onset of AP
function plotSpatialMaps(plotArrays, savePath, mask, regressionOrder)
figure
numRows = length(plotArrays);
numFrames = size(plotArrays(1).img, 3);
scaleMinMax = [-2, 2];
for frameN = 1:numFrames
     for imgN = 1:length(plotArrays)
         ax= subplot(numRows, numFrames, frameN + numFrames*(imgN-1));
         
         frame2plot = plotArrays(imgN).img(:,:, frameN);
         frame2plot(mask) = 0;
         imshow(frame2plot, scaleMinMax)
         
         if frameN == 1
             title(plotArrays(imgN).name)
         end
         if imgN == numRows && frameN == numFrames
             c = colorbar;
             c.Position = [ax.Position(1) + ax.Position(3) + ax.Position(3), ax.Position(2), ax.Position(3)/3, ax.Position(4)/3];
             c.Ticks = [-2, -1, 0, 1, 2];
         end         
         
     end
end

colormap('bluewhitered');
set(gcf,'units', 'centimeters', 'Position',[5,5,18,18]);
imgName = strcat(savePath, 'SupFig9_time_series_spatialMaps_', regressionOrder);

savefig(imgName)
saveas(gcf, imgName, 'pdf')
saveas(gcf, imgName, 'jpg')
close all
end
