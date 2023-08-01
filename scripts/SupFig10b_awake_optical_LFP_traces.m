%% Plot Sup Figure 10b imaging and LFP traces

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'SupFigure10b');
searchTerm = 'SupFigure10b_EMXJ21_example_LFP_imaging_traces.mat';
savePath = strcat(filePath, filesep, 'plots', filesep, 'SupFigure10b', filesep);
fileNamePrefix = 'SupFigure10b';
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

%% Load data for Sup Figure 10b
matchingFile = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(matchingFile.folder, filesep, matchingFile.name);
load(fullFN, 'traces2plot')

%% Plot
    IMG_x = traces2plot.IMG_x -2;
    LFP_x = traces2plot.LFP_x -2;
    selectedIMG_t_ind = find(IMG_x >=0 & IMG_x <= 6);
    selectedLFP_t_ind = find(LFP_x >=0 & LFP_x <= 6);
    img_t = IMG_x(selectedIMG_t_ind);
    img_y = traces2plot.regressed_g(selectedIMG_t_ind); % dFF %
    figure
    rg_line = plot(img_t, img_y + 2, 'LineWidth', lineWidth, 'color', 'b');
    shiftInd = 1;

    % plot all selected LFP channels
    LFPchannels = traces2plot.LFP_selectedChannel;
    lgds2 = nan(1, length(LFPchannels));
    img_t = IMG_x(selectedIMG_t_ind);
    lfp_t = LFP_x(selectedLFP_t_ind);
    lfps = ones(length(selectedLFP_t_ind), length(LFPchannels));
    counter = 1;
    for ind = 1:length(LFPchannels)
        hold on
        shift = 6.5 * (shiftInd);
        plot(lfp_t, -(traces2plot.LFP_y(selectedLFP_t_ind, ind))/100 - shift, 'LineWidth', lineWidth) 
        lgds2(shiftInd) = strcat('z-score: channel', num2str(ind),...
            ' at depth') + " " + strcat(num2str(30 * LFPchannels(ind) -30), ' \mum');
        shiftInd = shiftInd + 1;
        text(-0.7, -shift, {strcat(num2str(30 * LFPchannels(ind) -30), " \mum")}, 'HorizontalAlignment','center', 'FontSize', label_font)
        lfps(:, counter) = -traces2plot.LFP_y(selectedLFP_t_ind, ind);
        counter = counter + 1;
    end
    
    t = text(-1.1, -23, {'Relative channel distance'}, 'VerticalAlignment', 'middle', 'FontSize', label_font);
    t.Rotation = 90;
    
    plot([-1; -1], [-26; -4], 'LineWidth', lineWidth, 'Color', 'black')
    
    xline(traces2plot.APonsetT - 2, 'r--', {'AP onset'});
    xlim([-1.2, 5])
    hold on
    % Scale for imaging
    plot([0; 0.25], [-1.6; -1.6], '-k', 'LineWidth', lineWidth)
    plot([0; 0], [-1.6; 2.4 ], '-k', 'LineWidth', lineWidth)

    text(0.125,-2.3, '0.25s', 'HorizontalAlignment','center', 'FontSize', label_font)
    text(-0.025, 0.4, '4 %', 'HorizontalAlignment','right', 'FontSize', label_font)

    
    % Scale for LFP
    plot([0; 0.25], [-29; -29], '-k', 'LineWidth', lineWidth)
    plot([0; 0], [-29; -25], '-k', 'LineWidth', lineWidth)

    text(0.125,-30, '0.25s', 'HorizontalAlignment','center', 'FontSize', label_font)
    text(-0.025,-27, '400\muV', 'HorizontalAlignment','right', 'FontSize', label_font)
    text(-0.7, 2, {'Regressed', 'JEDI-1P', '- \Delta F/F_0'}, 'HorizontalAlignment','center', 'FontSize', label_font)

    % set(gca, 'XTick', [10:2:34], 'XTickLabel',  {[] 12:2:32 []})    % Used temporarily to get the ‘text’ positions correct
    set(gca, 'Visible', 'off')
    set(gcf,'units', 'centimeters', 'Position',[30,1,13.5,6.2]);


    currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
    figName = strcat(savePath, fileNamePrefix, 'awake_optical_LFP_ROI1_', currentDate);
    
    %% Following is the data shown in the Sup Figure 10b
    dataploted.img_t = img_t';
    dataploted.img_y = img_y;
    dataploted.lfp_t = lfp_t';
    dataploted.lfps = lfps;
    
    %% Save the plot
    savefig(figName)
    saveas(gcf, figName, 'png')
    saveas(gcf, figName, 'pdf')  