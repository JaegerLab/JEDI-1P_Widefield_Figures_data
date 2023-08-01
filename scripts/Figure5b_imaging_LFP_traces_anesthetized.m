%% Plot Figure 5b imaging and LFP traces

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure5b');
searchTerm = 'Figure5b_EMXJ18_20220215_trial112_LFP_imaging_traces.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure5b', filesep);

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

%% Load data for Figure 5b
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'traces2plot')

fileNamePrefix = erase(matchingFile.name, '.mat');
%% Plot

    img_ind = find(traces2plot.IMG_x >= 0 & traces2plot.IMG_x < 5);
    lfp_ind = find(traces2plot.LFP_x >= 0 & traces2plot.LFP_x < 5);
    img_t = traces2plot.IMG_x(img_ind);
    lfp_t = traces2plot.LFP_x(lfp_ind);
    img_y = -traces2plot.regressed_g(img_ind) * 100;
    figure

    rg_line = plot(img_t, img_y + 2, 'LineWidth', lineWidth, 'color', 'b');
    shiftInd = 1;

    % plot all selected LFP channels
    LFPchannels = traces2plot.LFP_selectedChannel;
    lgds2 = nan(1, length(LFPchannels));
    lfps = zeros(length(lfp_ind), length(LFPchannels));
    counter = 1;
    for ind = 1:length(LFPchannels)
        hold on
        shift = 6.5 * (shiftInd);
        lfps(:, ind) = -traces2plot.LFP_y(lfp_ind, ind);
        plot(lfp_t, lfps(:, ind)/100 - shift, 'LineWidth', lineWidth) 
        lgds2(shiftInd) = strcat('z-score: channel', num2str(ind),...
            ' at depth') + " " + strcat(num2str(30 * LFPchannels(ind) -30), ' \mum');
        shiftInd = shiftInd + 1;
        text(-0.7, -shift, {strcat(num2str(30 * LFPchannels(ind) -30), " \mum")}, 'HorizontalAlignment','center', 'FontSize', label_font)
        
    end
    
    t = text(-1.1, -23, {'Relative channel distance'}, 'VerticalAlignment', 'middle', 'FontSize', label_font);
    t.Rotation = 90;
    
    plot([-1; -1], [-26; -4], 'LineWidth', lineWidth, 'Color', 'black')

    xlim([-1.2, 5])
    hold on
    % Scale for imaging
    plot([0; 0.5], [-1.6; -1.6], '-k', 'LineWidth', lineWidth)
    plot([0; 0], [-1.6; 2.4 ], '-k', 'LineWidth', lineWidth)

    text(0.125,-2.3, '0.5s', 'HorizontalAlignment','center', 'FontSize', label_font)
    text(-0.025, 0.4, '4 %', 'HorizontalAlignment','right', 'FontSize', label_font)

    % Scale for LFP
    plot([0; 0.25], [-29; -29], '-k', 'LineWidth', lineWidth)
    plot([0; 0], [-29; -25], '-k', 'LineWidth', lineWidth)

    text(0.125,-30, '0.25s', 'HorizontalAlignment','center', 'FontSize', label_font)
    text(-0.025,-27, '400\muV', 'HorizontalAlignment','right', 'FontSize', label_font)
    text(-0.7, 2, {'Regressed', 'JEDI-1P', '- \Delta F/F_0'}, 'HorizontalAlignment','center', 'FontSize', label_font)

    set(gca, 'Visible', 'off')
    set(gcf,'units', 'centimeters', 'Position',[30,1,13.5,6.2]);
    %% Following is the data shown in the Sup Figure 10b
%     lfp_t = traces2plot.LFP_x

    dataploted.img_t = img_t';
    dataploted.img_y = img_y';
    dataploted.lfp_t = lfp_t';
    dataploted.lfps = lfps;
    
    %% Save the plot
    currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
    figName = strcat(savePath, 'Figure5b_', fileNamePrefix, '_ROI2_', currentDate);
%     
    savefig(figName)
    saveas(gcf, figName, 'png')
    saveas(gcf, figName, 'pdf')  