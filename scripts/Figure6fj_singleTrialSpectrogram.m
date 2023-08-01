%% Plot Figure 6f or 6j

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure6fj');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure6fj', filesep);

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

%% Plot
plotSpectrogram("AP", searchPath, savePath)
plotSpectrogram("Flicker", searchPath, savePath)
%% Function used for plotting
function plotSpectrogram(experimentType, searchPath, savePath)

switch experimentType
    case "AP"
        searchTerm = 'Figure6j_AP_ROI_trace_forSpectrogram.mat';
        filePrefix = 'Figure6j_AP_';
    case "Flicker"
        searchTerm = 'Figure6f_Flicker_ROI_trace_forSpectrogram.mat';
        filePrefix = 'Figure6f_Flicker_';
end

%% Find and load matching file
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'data2plot')

%% Plot spectrogram
figure
%% Calculate the spectrogram
% set parameters for the spectrogram; 
% the exact value might vary based on the data
% see help spectrogram for more information
Window = 160;
Noverlap = 128;
NFFT = 160;
Fs = 200;
% reshapedDFF = permute(squeeze(mean(reshapedDFF, 1)), [2,1]);
% use the spectrogram function
% set the type to either 'power' or 'psd' (power spectrum density)
[~,F,T,P] = spectrogram(data2plot.IMG_y, Window, Noverlap, NFFT, Fs, 'power');


%% Plot the spectrogram based on selected frequency range
% Manually set the ideal range
% The spectrogram tends to be dominant by the low frequency signal (<5 Hz)

% calculate the range of index based on the desired frequency range
FreqRange = [5, 70];
IndRange = round(FreqRange/(Fs/2) * length(F));
Indices = IndRange(1):IndRange(2);


surf(T,F(Indices, :),10*log10(P(Indices, :)),'edgecolor','none'); axis tight;
view(0,90)
c = colorbar;
c.Label.String = 'Power (dB)'; % would be dB/Hz if it's pds
c.Label.FontSize = 7;
c.Ticks = -110:20:-50;

% xline(5, 'r', 'LineWidth', 2);
xlabel('Time (s)', 'FontSize',7)
ylabel({'Spectrogram', 'frequency (Hz)'}, 'FontSize',7)
caxis([-110, -50])
xlim([0, 20.48])
yticks(10:10:70)
ax = gca;
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
set(ax.YAxis, 'TickDirection', 'out')
set(ax.XAxis, 'TickDirection', 'out')
set(gca, 'linewidth',1)
set(gca, 'FontSize',7)
set(gcf,'units', 'centimeters', 'Position',[10,1,5,4.5]);
c = colorbar;
colorBarPosition = c.Position;
colorBarPosition(3) = colorBarPosition(3) * 2/3;
colorBarPosition(1) = colorBarPosition(1) + 0.15;
c.Position = colorBarPosition;

currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat(savePath, filePrefix,'_spectrogram_', currentDate);

savefig(imgName)
saveas(gcf,imgName, 'png') 
print(strcat(imgName, '.pdf'), '-dpdf', '-painters')    
close all
end
