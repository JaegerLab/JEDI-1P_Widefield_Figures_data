
%% Plot Supplementary Figure 8 d
% Plot betas of ordinary least squares method of two regression approaches

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure8d');
searchTerm = 'SupFigure8d_betas_arrays2plot.mat'; 
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure8d', filesep);
fileNamePrefix = 'SupFigure8';

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
sequential_betas = data2plot.sequential_betas;
single_betas = data2plot.single_betas;
%% Mann Whiteney U test
% 1
[p_hearbeat,h1] = ranksum([sequential_betas.beta1],[single_betas.beta]);
[p_motion,h2] = ranksum([sequential_betas.beta2],[single_betas.beta]);
[p_slowHemo,h3] = ranksum([sequential_betas.beta3],[single_betas.beta]);

p = [p_slowHemo, p_motion, p_hearbeat];

%% New figure for third submission, change the plot to notBarPlot
seqRgLoc = 0.5:0.5:1.5;
singleRegLoc = 2.5;
heights = [6.4, 5.9, 5.4];
sequentiaBetas = cat(1, [sequential_betas.beta3], [sequential_betas.beta2], [sequential_betas.beta1])';
singleBeta = [single_betas.beta]';
figure 
notBoxPlot_adapted([sequential_betas.beta3], seqRgLoc(1),'style', 'errorBar', 'ColorScale', 'darkBlueScale', 'jitter', 0.2);
hold on
notBoxPlot_adapted([sequential_betas.beta2], seqRgLoc(2),'style', 'errorBar', 'ColorScale', 'orangeScale', 'jitter', 0.2);
notBoxPlot_adapted([sequential_betas.beta1], seqRgLoc(3),'style', 'errorBar', 'ColorScale', 'purpleScale', 'jitter', 0.2);
notBoxPlot_adapted(singleBeta, singleRegLoc, 'style', 'errorBar', 'ColorScale', 'darkRedScale', 'jitter', 0.2);

for sigstarN = 1:length(p)
    if p(sigstarN) > 0.05
        p(sigstarN) = nan;
    end
    sigstar([seqRgLoc(sigstarN), singleRegLoc], p(sigstarN), heights(sigstarN));
end

xlim([0 3])
ylim([-2, 7])
ax = gca;
ax.FontSize = axis_font; 
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
set(gca,'YTick', -2:2:7, 'linewidth',1)
set(gca, 'XTick', [seqRgLoc, singleRegLoc], 'linewidth',1)
xticklabels({'0-1 Hz', '1-10 Hz', '10-30 Hz', '0-30 Hz'})
xtickangle(ax,45)

ylabel('OLS coefficient \beta', 'FontSize', label_font)
set(gca,'box','off')
set(gcf,'units', 'centimeters', 'Position',[10,1,6,5.2]);

fileName = 'step-wise_vs_single-step_correction_notBarPlot';
imgName = strcat(savePath, '\', fileName);

savefig(imgName)
saveas(gcf,imgName, 'png') 
saveas(gcf,imgName, 'pdf') 