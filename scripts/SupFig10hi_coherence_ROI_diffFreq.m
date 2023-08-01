%% Plot Supplementary Figure 10c f from loaded data

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure10hi');
searchTerm = 'SupFigure10hi_coherence_diffFreqs.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure10hi', filesep);

%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end

%% Find and load matching file
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot')
coherence_2D_all = data2plot;

%% Set up parameters for plotting
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.5;
scale_font = 5;

colors_freq = turbo(8);
cmap = gray(10);
freqFields = coherence_2D_all.freqFields;
% meanCohere = zeros(129, 6);
% semCohere = zeros(129, 6);
for ROIN = [1,5]
figure
for freqN = 1:length(freqFields)
    freqStr = freqFields{freqN};
    Cxy_exp = data2plot.sum_freq_Cs.(freqStr);
    
    [~, ~] = CIshade_methods(Cxy_exp(:, :, ROIN)', 0.1, colors_freq(freqN+1, :), data2plot.f, [], '-');
%     meanCohere(:, freqN+1) = mean(Cxy_exp(:, :, ROIN), 2);
%     semCohere(:, freqN+1) = 1.96 * std(Cxy_exp(:, :, ROIN), [], 2)/sqrt(size(Cxy_exp, 2));
    hold on

end

hold on 
    Cxy_ctrl = data2plot.sum_Cxy_ctrl(:, :, ROIN);
    [lineOut, fillOut] = CIshade_methods(Cxy_ctrl', 0.1, cmap(1, :), data2plot.f, [], '-');
%     meanCohere(:, 1) = mean(Cxy_ctrl(:, :, ROIN), 2);
%     semCohere(:, 1) = 1.96 * std(Cxy_ctrl(:, :, ROIN), [], 2)/sqrt(size(Cxy_ctrl, 2));
    xlim([0 70])
ylim([0, 0.25])
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
set(gcf,'units','centimeters','Position',[30,1,5.4,3]);
legend('', '25 Hz', '', '30 Hz', '', '40 Hz', '', '50 Hz', '', '60 Hz', '', 'Baseline')
legend boxoff

if ROIN == 1
    imgName = strcat(savePath, filesep, 'SupFigure10h_LFP_img_mean_mag_sqr_coherence_CI95_20230328_allFreqs_ROI1i');
elseif ROIN == 5
    imgName = strcat(savePath, filesep, 'SupFigure10i_LFP_img_mean_mag_sqr_coherence_CI95_20230328_allFreqs_ROI1c');
end
savefig(imgName)
saveas(gcf,imgName, 'jpg')
saveas(gcf, imgName, 'pdf')
close all

end 