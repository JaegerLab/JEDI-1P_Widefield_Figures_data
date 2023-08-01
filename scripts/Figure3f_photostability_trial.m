%% Plot Figure 3f, photostability over 10s. 

IMG_sampleRate = 200;
%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure3f-i');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure3f-i', filesep);
searchTerm = '*fluorescence_trace_0801_2022.mat';

filelist = dir(fullfile(searchPath, '**', searchTerm));
%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end

%% Set up the parameters
duration = 20.48;
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.5;

%% Load files 
normalizedRawF_traces_masked = zeros(3, 100, 4096);
    fileCounter = 1;
    for fileN = 6:10:length(filelist)
        load(strcat(filelist(fileN).folder, filesep, filelist(fileN).name))
        if length(metaList) < 100 
            error('There are fewer than 100 trials in this session; choose another session')
            % should only be the case for 3 sessions
        else
            for trialN = 1:length(metaList)
                RawF_trace_masked = metaList(trialN).RawFluorescence.green.RawF_trace_masked;
                relativeIntensity = RawF_trace_masked(1, 1);
                normalized_RawF_trace_masked = RawF_trace_masked/relativeIntensity;
                normalizedRawF_traces_masked(fileCounter, trialN,:) = normalized_RawF_trace_masked;
            
            end
        end
        fileCounter = fileCounter + 1;
    end

    originalSize = size(normalizedRawF_traces_masked);
    normalizedTraces = reshape(normalizedRawF_traces_masked, [originalSize(1) * originalSize(2), originalSize(3)]);

%% Plot figure 3f

figure
    IMG_x = 0:(1/IMG_sampleRate):(duration - 1/IMG_sampleRate);% Set up x axis
    [lineOut, fillOut] = CIshade_methods(normalizedTraces, 0.1, [9, 112, 84]/256, IMG_x, [], '-');
    yticks(0:0.5:1.25)
    xlim([0, 20.48])
    ylim([0, 1.25])
    xlabel('Time (s)', 'FontSize', label_font)
    ylabel({'Normalized intensity'}, 'FontSize', label_font)
    ax = gca;
    ax.FontSize = axis_font; 
    ax.XRuler.TickLength = [0.06, 0.06];
    ax.YRuler.TickLength = [0.06, 0.06];
    ax.LineWidth = 1;
    set(gca,'box','off')
    lgd = legend('', 'JEDI-1P-Kv', 'FontSize', legend_font, 'Location', 'east');
    legend boxoff
    set(gcf,'units', 'centimeters', 'Position',[30,1,4.5,4]);

    currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
imgName = strcat(savePath, filesep, 'Figure3f_photostability_trial');
savefig(imgName)
saveas(gcf,imgName, 'png')   
saveas(gcf,imgName, 'pdf') 