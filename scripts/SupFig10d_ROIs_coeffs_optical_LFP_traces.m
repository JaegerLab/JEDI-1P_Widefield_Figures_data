%% Plot Figure 10d from loaded data

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure10d');
searchTerm = 'SupFigure10d_ROIs_coeffs_exp_shuffledControl.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure10d', filesep);
fileNamePrefix = 'SupFigure10d_';
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
sum_coeff_ROIs = data2plot.sum_coeff_ROIs_exp;
sum_coeff_ROIs_control = data2plot.sum_coeff_ROIs_control;
p = data2plot.P_values;
%%
experimentalLocations = 0.8:1:7.8;
controlLocations = 1.2:1:8.2;
figure
figStructExp = notBoxPlot_adapted(sum_coeff_ROIs, experimentalLocations,'style', 'errorBar', 'ColorScale', 'blueScale');

hold on
figStructCtrl = notBoxPlot_adapted(sum_coeff_ROIs_control, controlLocations, 'style', 'errorBar', 'ColorScale', 'grayScale');

for sigstarN = 1:8
    sigstar([experimentalLocations(sigstarN), controlLocations(sigstarN)], p(sigstarN), 0.5);
end
% 

xlim([0 8.5])
ylim([-0.5, 0.75])
title('Correlation between LFP and Regressed JEDI dF/F [1, 70]Hz', 'FontSize', 24)
ax = gca;
ax.FontSize = axis_font; 
set(gca,'linewidth',1)
xticks(1:8)
xticklabels({'1i', '2i', '3i', '4i', '1c', '2c', '3c', '4c'})
ax.YRuler.TickLength = [0.06, 0.06];
ax.LineWidth = 1;
xlabel('ROIs #', 'FontSize', label_font)
ylabel('Correlation Coefficient', 'FontSize', label_font)
set(gca,'box','off')
set(gcf,'units', 'centimeters', 'Position',[30,1,7,5]);

imgName = strcat(savePath, filesep, fileNamePrefix, 'ROIs_coeff_optcial_LFP');
savefig(imgName)
saveas(gcf,imgName, 'jpg')
print(strcat(imgName, '.pdf'), '-dpdf', '-painters')

%% Combine mean and SEM information
summaryStats = struct('meanExp', cell(1, length(figStructExp)));
for groupN = 1:length(figStructExp)
    summaryStats(groupN).meanExp = figStructExp(groupN).mu.YData(1);
    summaryStats(groupN).meanCtrl = figStructCtrl(groupN).mu.YData(1);
    summaryStats(groupN).SEMExp = figStructExp(groupN).errorBar.YPositiveDelta;
    summaryStats(groupN).SEMCtrl = figStructCtrl(groupN).errorBar.YPositiveDelta;
    summaryStats(groupN).originalExp = sum_coeff_ROIs(:, groupN);
    summaryStats(groupN).originalCtrl = sum_coeff_ROIs_control(:, groupN);
    
end
sumStatsFN = strcat(savePath, filesep, fileNamePrefix, '_ROIs_coeff_optcial_LFP');
save(sumStatsFN, 'summaryStats')
