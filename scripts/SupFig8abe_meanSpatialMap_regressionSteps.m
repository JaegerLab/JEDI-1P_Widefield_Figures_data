%% Plot Supplementary Figure 8 a, b, e
% Plot single-trial spectrogram of an ROI to compare different regression
% steps

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure8abe');
searchTerm = 'SupFigure8abe_EMXJ13_array2plot.mat'; 
savePath = strcat(filePath, filesep, 'plots', filesep, 'cSupFigure8abe', filesep);
fileNamePrefix = 'SupFigure8';
%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end
%% Set up parameters for plotting
fonts.axis_font = 7;
fonts.legend_font = 7;
fonts.label_font = 7;
fonts.title_font = 7;
fonts.lineWidth = 0.5;
fonts.scale_font = 5;

fileName_before = strcat(savePath, fileNamePrefix, 'a_trace_spectrogram_before_regression');
fileName_after_multiple = strcat(savePath, fileNamePrefix, 'b_trace_spectrogram_after_regression_multipleSteps');
fileName_after_single = strcat(savePath, fileNamePrefix, 'e_trace_spectrogram_after_regression_single_step');
%% Load data for plotting
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot');

%% Plot the two spectrogram to determine mininum and maximum values of colormap
Fs = data2plot.IMG_samplerate;
plotSpectrogram(data2plot.before_regression, Fs, fonts)
lim1 = caxis;
plotSpectrogram(data2plot.after_regression_multiple, Fs, fonts)
lim2 = caxis;
close all
% use minimum and maximum value for colormap scale
colormapRange = [min(lim1(1), lim2(1)), max(lim1(2), lim2(2))];

%% Plot Supplementary Figure 8a
plotSpectrogram(data2plot.before_regression, Fs, fonts)
caxis(colormapRange)
titleStr = strcat('Single trial JEDI-1P trace: before regression');
title(titleStr, 'FontSize',fonts.title_font)  
savefig(fileName_before)
saveas(gcf,fileName_before, 'jpg') 
print(strcat(fileName_before, '.pdf'), '-dpdf', '-painters')


%% Plot Supplementary Figure 8b
plotSpectrogram(data2plot.after_regression_multiple, Fs, fonts)
caxis(colormapRange)
titleStr = 'after step-wise regression';
title(titleStr, 'FontSize',fonts.title_font)  
savefig(fileName_after_multiple)
saveas(gcf,fileName_after_multiple, 'jpg') 
print(strcat(fileName_after_multiple, '.pdf'), '-dpdf', '-painters')

%% Plot Supplementary Figure 8e
plotSpectrogram(data2plot.after_regression_sigle, Fs, fonts)
caxis(colormapRange)
titleStr = 'after all-in-one regression';
title(titleStr, 'FontSize',fonts.title_font)  
savefig(fileName_after_single)
saveas(gcf,fileName_after_single, 'jpg') 
print(strcat(fileName_after_single, '.pdf'), '-dpdf', '-painters')


%% Function
function [] = plotSpectrogram(reshapedImg, Fs, fonts)

%% Calculate the spectrogram
% set parameters for the spectrogram; 
% the exact value might vary based on the data
% see help spectrogram for more information
Window = 160;
Noverlap = 128;
NFFT = 160;

% reshapedDFF = permute(squeeze(mean(reshapedDFF, 1)), [2,1]);
% use the spectrogram function
% set the type to either 'power' or 'psd' (power spectrum density)
[~,F,T,P] = spectrogram(reshapedImg, Window, Noverlap, NFFT, Fs, 'power');


%% Plot the spectrogram based on selected frequency range
% Manually set the ideal range
% The spectrogram tends to be dominant by the low frequency signal (<5 Hz)

% calculate the range of index based on the desired frequency range
FreqRange = [1, 70];
IndRange = round(FreqRange/(Fs/2) * length(F));
Indices = IndRange(1):IndRange(2);

figure
surf(T,F(Indices, :),10*log10(P(Indices, :)),'edgecolor','none'); axis tight;
view(0,90)
c = colorbar;
c.Label.String = 'dB'; % would be dB/Hz if it's pds
xlabel('Time (s)', 'FontSize', fonts.label_font)
ylabel('Frequency (Hz)', 'FontSize',fonts.label_font)
xlim([0 10])
titleStr = strcat('Single trial JEDI-1P trace: after single-step regression');
title(titleStr, 'FontSize',fonts.title_font)  
set(gcf,'Position',[100,1,900,600]);
% caxis(colormapRange)
ax = gca;
ax.FontSize = fonts.label_font;
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
set(ax.XAxis, 'TickDirection', 'out')
set(ax.YAxis, 'TickDirection', 'out')
set(gca, 'linewidth',1)
set(gcf,'units', 'centimeters', 'Position',[10,1,8,4.5]);
end