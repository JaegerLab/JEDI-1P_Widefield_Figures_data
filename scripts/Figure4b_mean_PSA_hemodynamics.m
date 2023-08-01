%% Plot Figure 4b mean PSA of a 2x2 ROI 

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure4b');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure4b', filesep);
searchTerm = 'Figure4b_EMXJ7_20211123_EKG_Img_PSA_regressed.mat';

%% Setup parameters for plotting
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.5;

%% Load file 
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN)

%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end

%% Plot mean PSA of 25 files
meanPSA = mean(dFF_PSAs, 3);
colors = {'k', [9, 112, 84]/256, 'b'};
color_counter = 1;
figure 
for traceN = 1:size(meanPSA, 2)

    plot(dff_frequency, meanPSA(:, traceN), 'LineWidth', lineWidth, 'color', colors{color_counter})
    hold on
    color_counter = color_counter + 1; 
end
set(gca,'linewidth',lineWidth)

xlim([0, 20])
ylim([-60, 10])
xlabel('Frequency (Hz)', 'FontSize', label_font)    
ylabel('Power spectral density (dB/Hz)', 'FontSize', label_font)
legend(["RFP reference", "JEDI-1P-kv before regression", "JEDI-1P-kv after regression"], 'FontSize', legend_font)

ax = gca;
ax.FontSize = axis_font; 
ax.FontSize = axis_font; 
set(ax.YAxis,'TickDir','out');
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
ax.LineWidth = 1;

set(gca,'box','off')
set(gcf,'units', 'centimeters', 'Position',[30,1,5.5,5]);
legend boxoff   
img = strcat(savePath, '\', 'Figure4b_EMXJ7_1123_2021_', 'mean_PSA_raw_dff_ROI_b70Hz_ROI4_Width2');

savefig(img)
saveas(gcf,img, 'png')
saveas(gcf, img, 'pdf')