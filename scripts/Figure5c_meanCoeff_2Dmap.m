%% Plot mean correlation coefficient 2D

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure5c');
searchTerm = strcat("EMXJ15", '*calculated0704_2022*_correlation_map_2D_channel*');
ROIsearchTerm = 'EMXJ15_20211023_LFP_ROIs.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure5b', filesep);

%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end
%% Find local matching data
filelist = dir(fullfile(searchPath, '**', searchTerm));
ROIfile = dir(fullfile(searchPath, '**', ROIsearchTerm));

%% Set up parameters for plotting
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 1;


%% Load each file
sum_coeff = zeros(50, 50, length(filelist)); % Pre-allocate the array

for fileN = 1:length(filelist)
fullFileName = strcat(filelist(fileN).folder, '\', filelist(fileN).name);
load(fullFileName)

reshaped_coeff_pixel = reshape(pixelWise_cor, 50, 50);
sum_coeff(:, :, fileN) = reshaped_coeff_pixel;
end


%% mask out non-cortex without warping
% Load masking files

map_fileName = 'EMXJ15_LFP_mask_0709_2022.png' ;
matchingMaskFile = dir(fullfile(searchPath, '**', map_fileName));
[maskImg,~] = imread(fullfile(matchingMaskFile.folder, matchingMaskFile.name));

%% get correct pixel size
maskImg = maskImg(:,:,1);
maskImg = imresize(maskImg, [50 50]); 
mask = maskImg < 200;
mean_coeff = mean(sum_coeff, 3);
% move the img to align with the mask
% shifted_mean_coeff = imtranslate(mean_coeff,[3, 0]);
minValue = min(mean_coeff, [], 'all');
maxValue = max(mean_coeff, [], 'all');

mean_coeff(mask) = 0;
%% Add ROIs 
% file path for regressed data with example ROIs
ROIFN = strcat(ROIfile.folder, filesep, ROIfile.name);
load(ROIFN);
ROIs = ROIs(2:9); % Select ROI2-9, ROI1 is immediately adjacent to recording site
I = imresize(mean_coeff, 2, 'nearest');

% Insert ROIs
% textPos = vertcat(ROIs(:).Numpos) * 5;
% textPos = textPos + [-2, -10];
color = {'black' ,'black','black','black','black'}';
numLabel = {'1', '2', '3', '4', '5'};

%%
imshow(I, 'InitialMagnification','fit')
colormap('Viridis')
c = colorbar;
c.Location = 'westoutside';
lim = caxis;
c.Label.String = 'Correlation coefficient';
c.Label.FontSize = label_font;
% c.TickLabels
caxis([minValue, maxValue]);
hold on
% add text 
for ROIN = 1:length(ROIs)
   
    textPos = [ROIs(ROIN).Numpos];
    squarePos_x = ROIs(ROIN).x;
    squarePos_y = ROIs(ROIN).y;
    x = [squarePos_x(1)-1, squarePos_x(1)+1, squarePos_x(1) + 1, squarePos_x(1)-1, squarePos_x(1)-1];
    y = [squarePos_y(1)-1, squarePos_y(1)-1, squarePos_y(1) + 1, squarePos_y(1) + 1, squarePos_y(1)];
%     plot(x, y, 'b-', '
    rectangle('Position',ROIs(ROIN).pos, 'LineWidth',1)
%     text(textPos(1) + 4, textPos(2), numLabel{ROIN}, 'FontSize', label_font)
end

set(gcf,'units', 'centimeters', 'Position',[30,1,9,6]);
currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));    
imgName = strcat(savePath, 'Figure5c_EMXJ15_mean_coeff_map_8ROIs_', currentDate);
% 

savefig(imgName)
saveas(gcf, imgName, 'png')
saveas(gcf, imgName, 'pdf')
close all

