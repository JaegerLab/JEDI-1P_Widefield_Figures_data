%% Figure 3c plot raw image of the widefield imaging view

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure3c');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure3c', filesep);
searchTerm = 'EMXJ7_20210811_001_RawF.mat'; % Name of the file to generate the figure

%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end
%% Find matching file 
dataFile = dir(fullfile(searchPath, '**', searchTerm));
% generate full filepath for the file of interest
fullFN = strcat(dataFile.folder, filesep, dataFile.name);
fileName = dataFile.name;

%% Extract AnimalID and file number
fileNameParts = split(fileName, '_RawF.mat');
fileNamePrefix = string(fileNameParts{1});

%% load the folder and remove the RawF structure
fileInfo = load(fullFN);
RawF = fileInfo.RawF;

%% Resize the 100 x 100 pixels image
avgImg = RawF.green.avgImg; % use the average image from JEDI-1P channel
I = mat2gray(avgImg);
I = imresize(I, 10, 'nearest');
%% Plot the image with selected ROIs 
%Plot square at each selected ROIs
% Reorganize ROIs so that the 1-3 are ROIs from left hemisphere
% and 4-6 are those from right hemisphere
ROI = RawF.green.ROI;
ROI_sorted = ROI([1, 3, 5, 2, 4, 6]);
resizeFactor = 10;
positions = zeros(length(ROI_sorted), 4);
for ROI_N = 1:length(ROI_sorted)
    roi = ROI_sorted(ROI_N);
    position = [(min(roi.x)-1)*resizeFactor+1, (min(roi.y)-1)*resizeFactor+1, resizeFactor * length(roi.x), resizeFactor * length(roi.y)];
    positions(ROI_N, :) = position;
end

textPos = vertcat(ROI_sorted(:).Numpos) * resizeFactor;
textPos = textPos + [-2, -10];
color = {'black' ,'black','black','black','black','black'}';
numLabel = {'1', '2', '3', '4', '5', '6'};
markedI_allROIs = insertShape(I,'Rectangle', positions, 'LineWidth', 4,...
                        'Color',color, 'Opacity',0.7);  

figure
imshow(markedI_allROIs)
set(gcf,'units', 'centimeters', 'Position',[20, 20,10,10]);

fileName = 'meanImg_ROI_numbered';
currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat(savePath, filesep, fileNamePrefix,'_', fileName, '_', currentDate, '.png');
imwrite(markedI_allROIs, imgName);

