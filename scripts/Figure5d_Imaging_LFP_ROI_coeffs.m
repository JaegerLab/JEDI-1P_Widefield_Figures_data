%% Plot Figure 5d from loaded data

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure5d');
searchTerm = 'Figure5d_EMXJ4_15_18_ROI_imaging_LFP_coeffs.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure5d', filesep);

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
load(fullFN)
%% 
sum_coeff_ROIs = data2plot.sum_coeff_ROIs;
sum_coeff_ROIs_control = data2plot.sum_coeff_ROIs_control;

mean_coeff_hf_ROIs = mean(sum_coeff_ROIs, 1);
mean_coeff_hf_ROIs_control = mean(sum_coeff_ROIs_control, 1);

error_coeff_hf_ROIs = std(sum_coeff_ROIs, 0, 1)/sqrt(length(sum_coeff_ROIs)) *1.96;
error_coeff_hf_ROIs_control = std(sum_coeff_ROIs_control, 0, 1)/sqrt(length(sum_coeff_ROIs_control)) * 1.96;


group_mean_coeff_hf_ROIs = [mean_coeff_hf_ROIs; mean_coeff_hf_ROIs_control]';
group_error_coeff_hf_ROIs = [error_coeff_hf_ROIs; error_coeff_hf_ROIs_control]';


% [h, p] = ttest(sum_coeff_ROIs,sum_coeff_ROIs_control);
p = nan(8, 1);
for ROI_N = 1:8
    [pi, hi] = ranksum(sum_coeff_ROIs(:, ROI_N), sum_coeff_ROIs_control(:, ROI_N));
    p(ROI_N, 1) = pi;

end

experimentalLocations = 0.8:1:7.8;
controlLocations = 1.2:1:8.2;
figure
notBoxPlot_adapted(sum_coeff_ROIs, experimentalLocations,'style', 'errorBar', 'ColorScale', 'blueScale')

hold on
notBoxPlot_adapted(sum_coeff_ROIs_control, controlLocations, 'style', 'errorBar', 'ColorScale', 'grayScale')


for sigstarN = 1:8
    sigstar([experimentalLocations(sigstarN), controlLocations(sigstarN)], p(sigstarN), []);
end
% 

xlim([0 9])
ylim([-0.2, 0.8])
% title('Correlation between LFP and Regressed JEDI dF/F [1, 70]Hz', 'FontSize', 24)
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

 currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat('Figure5d_EMXJ3_4_15_mean_anesthetized_SEM_', currentDate);
imgName = strcat(savePath, '\', imgName);
savefig(imgName)
saveas(gcf,imgName, 'jpg')
print(strcat(imgName, '.pdf'), '-dpdf', '-painters')
close all