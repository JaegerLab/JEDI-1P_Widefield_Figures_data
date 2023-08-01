%% Plot Supplementary Figure 10c f from loaded data

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure10cf');
searchTerm = 'SupFig10cf_array2plot.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure10cf', filesep);

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

%% Plot coefficient map of period without stimulation
plot2DcoeffMap(data2plot.mean_coeff_StimOff, savePath, "StimOff")
plot2DcoeffMap(data2plot.mean_coeff_StimOn, savePath, "StimOn")


%% Plot coefficient map of period with stimulation
%% Plot
% move the img to align with the mask
% shifted_mean_coeff = imtranslate(mean_coeff,[3, 0]);

function plot2DcoeffMap(mean_coeff, savePath, StimOnOff)

I = imresize(mean_coeff, 2, 'nearest');


%%
figure
imshow(I, 'InitialMagnification','fit')
% title(strcat(AnimalID, " mean of ", length(filelist), " trials"))
colormap('Viridis')
c = colorbar;
c.Location = 'westoutside';
caxis([-0.08, 0.12]);
c.Label.String = 'Correlation coefficient';
c.Label.FontSize = 7;

set(gcf,'units', 'centimeters', 'Position',[30,1,9,6]);
    
if StimOnOff == "StimOff"
    imgName = strcat(savePath, 'SupFigure10c_mean_coeff_map_2D_', StimOnOff);
elseif StimOnOff == "StimOn"
    imgName = strcat(savePath, 'SupFigure10f_mean_coeff_map_2D_', StimOnOff);
end

savefig(imgName)
saveas(gcf, imgName, 'jpg')
saveas(gcf, imgName, 'pdf')

end