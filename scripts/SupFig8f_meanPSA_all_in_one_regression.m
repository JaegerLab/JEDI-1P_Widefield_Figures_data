%% Plot Supplementary Figure 8 f
% Plot mean PSA before and after step-wise regression 
%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure8f');
searchTerm = 'SupFigure8f_EMXJ13_meanPSA_all-in-one_regression.mat'; 
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure8f', filesep);
fileNamePrefix = 'SupFigure8f';

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

%% Load data for plotting
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot');
        
meanPSA = data2plot.meanPSA;
dff_frequency = data2plot.dff_frequency;

%% Plot PSA

colors = {[9, 112, 84]/256, 'b'};
color_counter = 1;
figure %Plot PSA of all traces


for traceN = 1:size(meanPSA, 2)

    plot(dff_frequency, meanPSA(:, traceN), 'LineWidth',lineWidth, 'color', colors{color_counter})
    hold on
    color_counter = color_counter + 1; 
end
channelNames = {'JEDI-1P-Kv before regression', "'JEDI-1P-Kv after all-in-one regression "};
xlim([0, 50])
ylim([-60, 10])
xticks(0:25:50)
xlabel('Frequency (Hz)', 'FontSize', label_font)    
ylabel('Power spectral density (dB/Hz)', 'FontSize', label_font)
legend(channelNames, 'FontSize', legend_font)    

ax = gca;
ax.FontSize = axis_font; 
ax.FontSize = axis_font; 
set(ax.YAxis,'TickDir','out');
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
ax.LineWidth = 1;
set(gca,'box','off')
set(gcf,'units', 'centimeters', 'Position',[30,1,4.5,4.5]);
legend boxoff  
imgName = strcat(savePath, filesep, fileNamePrefix, '_mean_PSA_regression_before_vs_after_all-in-one');
savefig(imgName)
saveas(gcf,imgName, 'jpg') 
saveas(gcf, imgName, 'pdf')

