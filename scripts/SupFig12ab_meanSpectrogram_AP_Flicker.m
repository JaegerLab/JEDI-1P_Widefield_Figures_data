%% Plot Supplementary Figure 12
% Plot mean spectrogram of all traces 

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure12ab');
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure12ab', filesep);

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

%% Plot for each experiment
plotSpectrogram("AP", searchPath, savePath)
plotSpectrogram("Flicker", searchPath, savePath)

function plotSpectrogram(experimentType, searchPath, savePath)
switch experimentType
    case "AP"
        searchTerm = 'SupFig12_AP_ROI_traces_allMice.mat';
        saveFilePrefix = 'SupFig12b_';
    case "Flicker"
        searchTerm = 'SupFig12_Flicker_ROI_traces_allMice.mat';
        saveFilePrefix = 'SupFig12a_';
end

%% Information of the imaging data
Fs = 200; % frames/s
duration = 20.48; % duration of imaging
%% Find matching file
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
matchingFN = strcat(matchingFile.folder, filesep, matchingFile.name);

%% Load data
load(matchingFN, 'allTraces');
traces = [allTraces.regressed_g];

%% Calculate the spectrogram
% set parameters for the spectrogram; 
% the exact value might vary based on the data
% see help spectrogram for more information

%reshapedImg could be an array of regressed traces 
% first dimension is the number of trials, and second dimension is the
% sample number
numTrials = size(traces, 1); % should be trial * imageFrame

% permute data if the shape of the input array is reversed
if numTrials(1) == Fs * duration
    traces = permute(traces, [2, 1]);
    numTrials = size(traces, 1);
end

Window = 160; %floor(length(reshapedImg)/12);
Noverlap = floor(0.75 * Window);
NFFT = 160;

% Pre-assign 

[~,F,T,P] = spectrogram(traces(1, :), Window, Noverlap, NFFT, Fs, 'power');

P_sum = zeros([size(P), numTrials()]);

for trialN = 1:size(traces, 1)
% use the spectrogram function
% set the type to either 'power' or 'psd' (power spectrum density)
[~,F,T,P_sum(:, :, trialN)] = spectrogram(traces(trialN, :), Window, Noverlap, NFFT, Fs, 'power');

%% Plot the spectrogram based on selected frequency range
% Manually set the ideal range
% The spectrogram tends to be dominant by the low frequency signal (<5 Hz)


end
%%

% calculate the range of index based on the desired frequency range
FreqRange = [10, 70];
IndRange = round(FreqRange/(Fs/2) * length(F));
Indices = IndRange(1):IndRange(2);


mean_P_sum = mean(P_sum, 3);
surf(T, F(Indices, :),10*log10(mean_P_sum(Indices, :)),'edgecolor','none'); axis tight;
view(0,90)
ax = gca;
c = colorbar;
c.Label.String = 'Power (dB)'; % would be dB/Hz if it's pds
c.Label.FontSize = 7;
c.Label.FontName = 'Arial';
c.Location = 'eastoutside';
xlabel('Time (s)', 'FontSize',7)
ylabel('Frequency', 'FontSize',7)
ax.XRuler.TickLength = [0.06, 0.06];
ax.YRuler.TickLength = [0.06, 0.06];
set(ax.XAxis,'TickDirection','out')
set(ax.YAxis,'TickDirection','out')
set(gca,'linewidth',1)
title(strcat("Mean spectrogram of ", experimentType))
set(gcf,'units','centimeters','Position',[30,1,7,5]);
imgName = strcat(savePath, saveFilePrefix, 'mean_spectrogram_', experimentType);
savefig(imgName)
saveas(gcf, imgName, 'png')
print(strcat(imgName, '.pdf'), '-dpdf', '-painters')  

close all
end 
