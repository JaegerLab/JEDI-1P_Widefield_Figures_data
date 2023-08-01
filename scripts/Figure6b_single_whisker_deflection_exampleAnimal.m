%% Plot Figure 6b

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure6b');
searchTerm = 'Figure6b_EMXJ32_singleWhiskerDeflection_meanSpatialMap.mat';
searchTermMask = 'Masking_standard.png';
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure6b', filesep);

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
load(fullFN, 'meanAllDeflections')

%% Load mask
matchingMask = dir(fullfile(searchPath, '**', searchTermMask));
fullMaskFN = strcat(matchingMask.folder, filesep, matchingMask.name);
mask = imread(fullMaskFN);

mask = imresize(mask(:, :, 1), [size(meanAllDeflections, 1), size(meanAllDeflections,1)], 'nearest');
mask = mask ~= 0;
%% Plot

colorScaleMax = 2;
colorScaleMin = -2;
color_axis = [colorScaleMin, colorScaleMax];

for frameN = 1:size(meanAllDeflections, 3)
% trim the top and bottom
    ax = subplot(2, 5, frameN);
    image2plot = meanAllDeflections(:, :, frameN);
    image2plot(mask) = 0;
    imshow(image2plot, color_axis);
    colormap('bluewhitered');
    title(strcat(string((frameN-2)*5), " ms"));  
    if frameN == size(meanAllDeflections, 3) % last frame 
        c = colorbar;
        c.Position = [ax.Position(1) + ax.Position(3) + ax.Position(3)/20, ax.Position(2), ax.Position(3)/10, ax.Position(4)];
    end
end

    set(gcf, 'Position', [10, 10, 600, 200])
    figName = strcat(savePath, 'Figure6b_singleWhisker_EMXJ32_all_deflections_mean_-DFF');
    savefig(figName)
    saveas(gcf, figName, 'png') 
    saveas(gcf, figName, 'pdf')
   

    
