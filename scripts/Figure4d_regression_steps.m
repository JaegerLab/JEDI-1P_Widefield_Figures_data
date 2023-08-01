%% Plot a set of example to show regression pipeline

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure4d');
searchTerm = 'EMXJ13_20210923_Trial016_regressed_traces_width2.mat';

savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure4d', filesep);

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
%% Find a list files that contain the regressedc traces
fileList = dir(fullfile(searchPath, '**', searchTerm));

%% Load data
% load regressed data: 
load(strcat( fileList.folder, filesep, fileList.name))
traces = ROI_traces.traces;

fileName = ROI_traces.matchingFiles.imgA_name;
fileNameParts = split(fileName, '_');
AnimalID = fileNameParts{1};
trialInd = split(fileNameParts{2}, '-');
trialInd = trialInd{2};
dateYYYYMMDD = string(datetime(ROI_traces.matchingFiles.imgB.acquisitionDateTime, 'Format', 'yyyyMMdd'));
fileNamePrefix = strcat('Figure4d_', AnimalID, '_', dateYYYYMMDD, '_trial', trialInd, '_');

%% Set parameters
IMG_sampleRate = 200;
duration = 20.48;
ROIN = 'ROI4'; % ROI of interest

% raw dFF without filtering
dff_r = traces.(ROIN).dff.dff_r;
dff_g = traces.(ROIN).dff.dff_g;
dff_g_b70Hz = traces.(ROIN).dff.dff_g_b70Hz;

% Step1 remove fast hemodynamics
dff_r_heartbeat = traces.(ROIN).dff.dff_r_heartbeat;
regressed_g_step1 = traces.(ROIN).regressed_traces.regressed_g_descending_step1;

% Step2 remove motion artifact 
dff_r_motion = traces.(ROIN).dff.dff_r_motion;
regressed_g_step2 = traces.(ROIN).regressed_traces.regressed_g_descending_step2;

% Step3 remove slow hemodynamics
dff_r_slowHemo = traces.(ROIN).dff.dff_r_slowHemo;
regressed_g_step3 = traces.(ROIN).regressed_traces.regressed_g_descending_step3;


IMG_x = 0:(1/IMG_sampleRate):(duration - 1/IMG_sampleRate);
img_range_y = 801:1400; % select index to plot
img_range_x = 1:600;


xlim_range = [-2 3.5];
ylim_range = [-0.04 0.12];

%% Calculate frames for Airpuff
airpuffOnset = ROI_traces.matchingFiles.AirpuffTime - ROI_traces.matchingFiles.ImgSyncOnset;


% adjusted the airpuff time 
airpuffOnset = airpuffOnset - 4; % manually shift it by 4 s
APFrameOnset = find(IMG_x > airpuffOnset, 1, 'first');
APFrameOffset = APFrameOnset + IMG_sampleRate * 0.5;

airpuffDur = [airpuffOnset, airpuffOnset + 0.5];

%% Plot Raw Traces

%Set loacation for traces: 
x_loc = -1.25;
red_pos1 = [x_loc, 0.05];
green_pos1 = [x_loc, 0];

figure
plot(IMG_x(img_range_x), dff_r(img_range_y) + red_pos1(2), 'LineWidth', lineWidth, 'color', 'k')
hold on
plot(IMG_x(img_range_x), dff_g(img_range_y) + green_pos1(2), 'LineWidth', lineWidth, 'color', [9, 112, 84]/256)

scaleLoc_x = -0.1;
scaleLoc_y = -0.012;
hold on

plot([scaleLoc_x; scaleLoc_x + 0.25], [scaleLoc_y; scaleLoc_y], '-k', 'LineWidth', lineWidth)
plot([scaleLoc_x; scaleLoc_x], [scaleLoc_y; scaleLoc_y + 0.01], '-k', 'LineWidth', lineWidth)

text(scaleLoc_x + 0.125, scaleLoc_y - 0.005, '0.25 s', 'HorizontalAlignment','center', 'FontSize', scale_font)
text(scaleLoc_x - 0.25,scaleLoc_y + 0.005, '1%', 'HorizontalAlignment','center', 'FontSize', scale_font)

text(red_pos1(1),red_pos1(2), {'Reference', '\DeltaF/F_0'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)
text(green_pos1(1),green_pos1(2), {'JEDI-1P', '\DeltaF/F_0'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)

% Plot AP stimulation 
plot([airpuffOnset; airpuffOnset + 0.5], [-0.025; -0.025], '-k', 'LineWidth', lineWidth)
text(airpuffOnset + 0.25, -0.035, {'40 Hz', 'Air-puff'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)

xlim(xlim_range)
ylim(ylim_range)
set(gca, 'Visible', 'off')
set(gcf,'units', 'centimeters', 'Position',[30,1,7.2,4.32]);


imgName = strcat(savePath, '\', fileNamePrefix, '_raw_traces');
savefig(imgName)
saveas(gcf,imgName, 'png')
saveas(gcf,imgName, 'pdf')

%% Plot Step 1 Regression 

%Set loacation for traces: 
x_loc = -1.25;
red_pos1 = [x_loc, 0.1];
green_pos1 = [x_loc, 0.05];
green_pos2 = [x_loc, 0];

figure
plot(IMG_x(img_range_x), dff_r_heartbeat(img_range_y) + red_pos1(2), 'LineWidth', lineWidth, 'color', 'k')
hold on
plot(IMG_x(img_range_x), dff_g_b70Hz(img_range_y) + green_pos1(2), 'LineWidth', lineWidth, 'color', [9, 112, 84]/256)
hold on
plot(IMG_x(img_range_x), regressed_g_step1(img_range_y) + green_pos2(2), 'LineWidth', lineWidth, 'color', 'b')

scaleLoc_x = -0.04;
scaleLoc_y = -0.02;
hold on

plot([scaleLoc_x; scaleLoc_x + 0.25], [scaleLoc_y; scaleLoc_y], '-k', 'LineWidth', lineWidth)
plot([scaleLoc_x; scaleLoc_x], [scaleLoc_y; scaleLoc_y + 0.01], '-k', 'LineWidth', lineWidth)
% axis([[10  34]    -60  140])
text(scaleLoc_x + 0.125, scaleLoc_y - 0.005, '0.25 s', 'HorizontalAlignment','center', 'FontSize', scale_font)
text(scaleLoc_x - 0.25,scaleLoc_y + 0.005, '1%', 'HorizontalAlignment','center', 'FontSize', scale_font)
% text(-0.4,red_pos(2) + 1, 'Z-score', 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', 16)

text(red_pos1(1),red_pos1(2), {'Reference {\it r_1}', '\DeltaF/F_0 [10, 30]Hz'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)
text(green_pos1(1),green_pos1(2), {'JEDI-1P {\it g_1}', '\DeltaF/F_0 [0, 70]Hz'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)
text(green_pos2(1),green_pos2(2), {'Step 1 outcome {\it g_2}', '\DeltaF/F_0 [0, 70]Hz'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)

xlim(xlim_range)
ylim(ylim_range)
set(gca, 'Visible', 'off')
set(gcf,'units', 'centimeters', 'Position',[30,1,7.2,4.32]);


imgName = strcat(savePath, '\', fileNamePrefix, '_step1');
savefig(imgName)
saveas(gcf,imgName, 'png')
saveas(gcf,imgName, 'pdf')

%% Plot Step 2 Regression 

%Set loacation for traces: 
x_loc = -1.25;
red_pos1 = [x_loc, 0.05];
green_pos1 = [x_loc, 0.05];
green_pos2 = [x_loc, 0];

figure
plot(IMG_x(img_range_x), dff_r_motion(img_range_y) + red_pos1(2), 'LineWidth', lineWidth, 'color', 'k')
hold on
plot(IMG_x(img_range_x), regressed_g_step2(img_range_y) + green_pos2(2), 'LineWidth', lineWidth, 'color', 'b')

scaleLoc_x = -0.04;
scaleLoc_y = -0.02;
hold on

plot([scaleLoc_x; scaleLoc_x + 0.25], [scaleLoc_y; scaleLoc_y], '-k', 'LineWidth', lineWidth)
plot([scaleLoc_x; scaleLoc_x], [scaleLoc_y; scaleLoc_y + 0.01], '-k', 'LineWidth', lineWidth)

text(scaleLoc_x + 0.125, scaleLoc_y - 0.005, '0.25 s', 'HorizontalAlignment','center', 'FontSize', scale_font)
text(scaleLoc_x - 0.25,scaleLoc_y + 0.005, '1%', 'HorizontalAlignment','center', 'FontSize', scale_font)

text(red_pos1(1),red_pos1(2), {'Reference {\it r_2}', '\DeltaF/F_0 [1, 10]Hz'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)
text(green_pos2(1),green_pos2(2), {'Step 2 outcome {\it g_3}', '\DeltaF/F_0 [0, 70]Hz'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)

xlim(xlim_range)
ylim(ylim_range)
set(gca, 'Visible', 'off')
set(gcf,'units', 'centimeters', 'Position',[30,1,7.2,4.32]);


imgName = strcat(savePath, '\', fileNamePrefix, '_step2');
savefig(imgName)
saveas(gcf,imgName, 'png')
saveas(gcf,imgName, 'pdf')
%% Plot Step 3 Regression 

%Set loacation for traces: 
x_loc = -1.25;
red_pos1 = [x_loc, 0.05];
% green_pos1 = [x_loc, 0.05];
green_pos2 = [x_loc, 0];

figure
plot(IMG_x(img_range_x), dff_r_slowHemo(img_range_y) + red_pos1(2), 'LineWidth', lineWidth, 'color', 'k')
hold on
plot(IMG_x(img_range_x), regressed_g_step3(img_range_y) + green_pos2(2), 'LineWidth', lineWidth, 'color', 'b')

scaleLoc_x = -0.04;
scaleLoc_y = -0.02;
hold on

xaxis_pos = [-0.5, -0.01];

plot([scaleLoc_x; scaleLoc_x + 0.25], [scaleLoc_y; scaleLoc_y], '-k', 'LineWidth', lineWidth)
plot([scaleLoc_x; scaleLoc_x], [scaleLoc_y; scaleLoc_y + 0.01], '-k', 'LineWidth', lineWidth)

text(scaleLoc_x + 0.125, scaleLoc_y - 0.005, '0.25 s', 'HorizontalAlignment','center', 'FontSize', scale_font)
text(scaleLoc_x - 0.25,scaleLoc_y + 0.005, '1%', 'HorizontalAlignment','center', 'FontSize', scale_font)

text(red_pos1(1),red_pos1(2), {'Reference {\it r_3}', '\DeltaF/F_0 [0, 1]Hz'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)
text(green_pos2(1),green_pos2(2), {'JEDI-1P after regression', '{\it j} \DeltaF/F_0 [0, 70]Hz'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)

% Plot AP stimulation 
plot([airpuffOnset; airpuffOnset + 0.5], [-0.005; -0.005], '-k', 'LineWidth', lineWidth)
text(airpuffOnset + 0.25, -0.015, {'40 Hz', 'Air-puff'}, 'fontweight','bold', 'HorizontalAlignment','center', 'FontSize', label_font)


xlim(xlim_range)
ylim(ylim_range)
set(gca, 'Visible', 'off')
set(gcf,'units', 'centimeters', 'Position',[30,1,7.2,4.32]);


imgName = strcat(savePath, '\', fileNamePrefix, '_step3');
savefig(imgName)
saveas(gcf,imgName, 'png')
saveas(gcf,imgName, 'pdf')
