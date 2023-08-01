%% Plot Supplementary Figure 8 h
% Plot mean PSA before and after step-wise regression for mice that express
% tdTomato as the reference channel
%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure8h');
searchTerm = 'SupFigure8g_EMXJ17_JEDI_tdTomato_PSA.mat'; 
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure8h', filesep);
fileNamePrefix = 'SupFigure8h';

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

%% Load mean PSA        

meanPSA = data2plot.meanPSA;
dff_frequency = data2plot.dff_frequency;

colors = {'k', [9, 112, 84]/256};
color_counter = 1;

%% Plot mean PSA
figure %Plot PSA of all traces

for traceN = 1:size(meanPSA, 2)

    plot(dff_frequency, meanPSA(:, traceN), 'LineWidth',lineWidth, 'color', colors{color_counter})
    hold on
    color_counter = color_counter + 1; 
end
channelNames = {'Reference channel', "'JEDI-1P channel"};
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
imgName = strcat(savePath, fileNamePrefix, '_mean_PSA_JEDI-1P_tdTomato_channels');
savefig(imgName)
saveas(gcf,imgName, 'jpg') 
saveas(gcf, imgName, 'pdf')