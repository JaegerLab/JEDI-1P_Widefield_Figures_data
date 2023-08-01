%% Plot Supplementary Figure 11

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure11');
searchTerm = 'SupFig11_EMXJ*_SingleWhisker_allDeflections_eventAligned_shifted.mat';
searchTermMask = 'Masking_standard.png';
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure11', filesep);

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
%% Set up parameters for plotting
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.5;
scale_font = 5;

%% Find and load matching file, plot mean spatial map for each animal
machingFiles = dir(fullfile(searchPath, '**', searchTerm));

for fileN = 1:length(machingFiles)
fullFN = strcat(machingFiles(fileN).folder, filesep, machingFiles(fileN).name);
load(fullFN, 'sumArray')
meanAllDeflections = mean(sumArray, 4);

if fileN == 1
    allMiceDeflections = meanAllDeflections;
else
    allMiceDeflections = cat(4, allMiceDeflections, meanAllDeflections);
end
% extract animal information
nameParts = split(machingFiles(fileN).name, '_');
AnimalID = nameParts{2};

%set the upper and lower bound of the color scale
colorScaleMax = 2;
colorScaleMin = -2;
color_axis = [colorScaleMin, colorScaleMax];

for frameN = 1:size(meanAllDeflections, 3)
% trim the top and bottom
    subplot(2, 5, frameN)
    img2plot = meanAllDeflections(:, :, frameN);
    img2plot(mask) = 0;
    imshow(img2plot, color_axis);
    colormap('bluewhitered'); % bluewhitered function is necessary here
    title(strcat(string((frameN-2)*5), " ms"));  
    if frameN == size(meanAllDeflections, 3) % last frame 
        colorbar;
    end

end
    sgtitle(strcat(AnimalID, " mean dFF spatial frames"))
    set(gcf, 'Position', [10, 10, 600, 200])
    figName = strcat(savePath, 'SupFigure11_', AnimalID, '_all_deflections_mean_-DFF');
    savefig(figName)
    saveas(gcf, figName, 'pdf')
    saveas(gcf, figName, 'jpg')    
    close all
end

%% Plot mean deflection response of all mice
allMiceMean = mean(allMiceDeflections, 4);
for frameN = 1:size(allMiceMean, 3)
% trim the top and bottom
    subplot(2, 5, frameN)
    img2plot = meanAllDeflections(:, :, frameN);
    img2plot(mask) = 0;
    imshow(img2plot, color_axis);
    colormap('bluewhitered'); % bluewhitered function is necessary here
    title(strcat(string((frameN-2)*5), " ms"));  
    if frameN == size(allMiceMean, 3) % last frame 
        colorbar;
    end

end
    sgtitle(strcat(AnimalID, " mean dFF spatial frames"))
    set(gcf, 'Position', [10, 10, 600, 200])
    figName = strcat(savePath, 'SupFigure11_allMice_all_deflections_mean_-DFF');
    savefig(figName)
    saveas(gcf, figName, 'pdf')
    saveas(gcf, figName, 'jpg')    
    close all
