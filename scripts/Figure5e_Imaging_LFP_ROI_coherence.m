%% Plot Figure 5e

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure5e');
searchTerm = 'Figure5e_EMXJ4_15_18_LFP_imaging_coherence_ROI.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure5e', filesep);

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

%% Load data for Figure 5b
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot')

%% Plot
selectedPoints = data2plot.selectedPoints;
sum_Cxy_exp = data2plot.sum_Cxy_exp;
sum_Cxy_ctrl = data2plot.sum_Cxy_ctrl;
f = data2plot.f;
colors = {[0 0.4470 0.7410], [0.8500 0.3250 0.0980], [0.9290 0.6940 0.1250], [0.4940 0.1840 0.5560], [0.4660 0.6740 0.1880], ...
    'blue', 'magenta', 'cyan'};

legendStr = cell(18, 1);
figure
for pointN = 1:4

    Cxy_exp = sum_Cxy_exp(:, :, selectedPoints(pointN));
    [lineOut, fillOut] = CIshade_methods(Cxy_exp', 0.1, colors{pointN}, f, [], '-');
    legendStr{pointN * 2 - 1} = '';
    legendStr{pointN * 2} = strcat(string(pointN), 'i');
    hold on
end
counter = 1;
for pointN = 5:8

    Cxy_exp = sum_Cxy_exp(:, :, selectedPoints(pointN));
    [lineOut, fillOut] = CIshade_methods(Cxy_exp', 0.1, colors{counter}, f, [], '--');
    legendStr{pointN * 2 - 1} = '';
    legendStr{pointN * 2} = strcat(string(pointN), 'c');
    hold on
    counter = counter + 1;
end

cmap = gray(10);

for pointN = 1:length(selectedPoints)

    Cxy_ctrl = sum_Cxy_ctrl(:, :, selectedPoints(pointN));
    [lineOut, fillOut] = CIshade_methods(Cxy_ctrl', 0.1, cmap(pointN, :), f, [], '-');
    hold on
end
legendStr{2 * pointN + 1} = '';
legendStr{2 * pointN + 2} = 'Shuffled';

for legendN = 1:length(legendStr)
    
end
legend(legendStr, 'FontSize', legend_font, 'Location', 'northeast')
xlim([0 70])
ax = gca;
ax.FontSize = axis_font; 
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
set(ax.XAxis,'TickDirection','out')
set(ax.YAxis,'TickDirection','out')
set(gca,'linewidth',1)
xlabel('Frequency (Hz)')
ylabel({'Optical recording-LFP', 'magnitude-squared coherence'}, 'FontSize', label_font)
set(gca,'box','off')
set(gcf,'units','centimeters','Position',[30,1,5.4,5]);
legend boxoff

currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat(savePath, '\', 'Figure5e_EMXJ4_15_18_LFP_img_mean_mag_sqr_coherence_CI95_', currentDate);

savefig(imgName)
saveas(gcf,imgName, 'png')
saveas(gcf, imgName, 'pdf')


