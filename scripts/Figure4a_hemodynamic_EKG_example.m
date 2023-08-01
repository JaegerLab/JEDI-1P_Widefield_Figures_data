%% Plot Figure 4a, EKG and imaging example traces

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure4a');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure4a', filesep);
searchTerm = 'EMXJ7_20211123_Trial025_imaging_EKG_forPlotting.mat';

%% Generate save directory if it does not already exist
if ~isfolder(savePath)
    mkdir(savePath)
end

%% Set parameters for scaling and plotting
EKG_fs = 500; %EKG acquisition rate
EKG_pass_fs = 70; %low pass filter for LFP data

img_pass_fs = 70; %low pass filter for LFP data
steepness = 0.95;
duration = 20.48; %imaging trial duration
LFP_sampleRate = 20000; % /s
IMG_sampleRate = 200; % /s

axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.5;

scale_font = 5;

%% color and label arrays for labeling ROIs
colors = {'blue', 'green', 'red','cyan', 'magenta', 'yellow', 'black', 'white'};
labels = {'1', '2', '3', '4', '5', '6', '7', '8', '9'};

%% Find matching  file

filelist = dir(fullfile(searchPath, '**', searchTerm));
fullFN = strcat(filelist.folder, filesep, filelist.name);
load(fullFN, 'traces2plot')

filenamePrefex = erase(filelist.name, 'forPlotting.mat');
    figure
    shift_x = 2.1;
    %Set location for labels and scale bar
    EKG_pos = [-0.25  + shift_x, 7];
    dff_red_pos = [-0.25 + shift_x, 5];
    dff_raw_g_pos = [-0.25 + shift_x, 3];
    dff_green_pos = [-0.25 + shift_x, -1.5];
    dff_rg_pos = [-0.25 + shift_x, -4.5];

    % location for the label of scale bar for dff
    x_axis_txt_pos = [0.2 + shift_x, -2.9] ;
    y_axis_txt_pos = [0.05 + shift_x, -2.2] ;
    % location for the label of scale bar for ECG
    x_axis_txt_pos_EKG = [x_axis_txt_pos(1), 2.2];
    y_axis_txt_pos_EKG = [y_axis_txt_pos(1), 2.6];            

    plot(traces2plot.EKG_x, traces2plot.EKG_y + EKG_pos(2), 'LineWidth', lineWidth, 'color', [0.4940 0.1840 0.5560])
    hold on
    plot(traces2plot.IMG_x, traces2plot.dff_r_b20Hz * 100 + dff_red_pos(2), 'LineWidth', lineWidth, 'color', 'k')
    hold on 
    plot(traces2plot.IMG_x, traces2plot.dff_g_raw * 100 + dff_raw_g_pos(2), 'LineWidth', lineWidth, 'color', [9, 112, 84]/256)

    plot(traces2plot.IMG_x, traces2plot.dff_g_b70Hz * 100 + dff_green_pos(2), 'LineWidth', lineWidth, 'color', [9, 112, 84]/256)

    plot(traces2plot.IMG_x, traces2plot.dff_g_rg * 100 + dff_rg_pos(2), 'LineWidth', lineWidth, 'color', 'b')

    for lineN = 1:length(traces2plot.line_x)
        xline(traces2plot.line_x(lineN), '--', 'LineWidth', lineWidth, 'color', [0 0.4470 0.7410])
    end
    xlim([2, 7.5])
    xlabel('Time (s)', 'FontSize', label_font)
    ylabel('dFF (%)', 'FontSize', label_font)

    %plot scale bars for dff
    plot([0.1; 0.6] + shift_x, [-2.7; -2.7], '-k', 'LineWidth', 0.75)
    plot([0.1; 0.1] + shift_x, [-2.7; -0.7], '-k', 'LineWidth', 0.75)
    %label scale bars
    text(x_axis_txt_pos(1), x_axis_txt_pos(2), '0.5 s', 'HorizontalAlignment','center', 'FontSize', scale_font)
    text(y_axis_txt_pos(1), y_axis_txt_pos(2), '2 %', 'HorizontalAlignment','center', 'FontSize', scale_font)

    %plot scale bars for scaled EKG
    plot([0.1; 0.6] + shift_x, [2.4; 2.4], '-k', 'LineWidth', 0.75)
    plot([0.1; 0.1] + shift_x, [2.4; 3.6], '-k', 'LineWidth', 0.75)
    %label scale bars
    text(x_axis_txt_pos(1), x_axis_txt_pos_EKG(2), '0.5 s', 'HorizontalAlignment','center', 'FontSize', scale_font)
    text(y_axis_txt_pos(1), y_axis_txt_pos_EKG(2), '3', 'HorizontalAlignment','center', 'FontSize', scale_font)                

    %label traces
    text(EKG_pos(1) , EKG_pos(2), {'EKG', 'Z-score'}, 'HorizontalAlignment','center', 'fontweight','bold', 'FontSize', label_font)
    text(dff_red_pos(1), dff_red_pos(2), {'Reference', 'channel', '\DeltaF/F_0 [0, 20] Hz'}, 'HorizontalAlignment','center', 'fontweight','bold','FontSize', label_font)
    text(dff_green_pos(1), dff_green_pos(2), {'JEDI-1P-Kv', 'channel', '\DeltaF/F_0 [0, 70] Hz'}, 'HorizontalAlignment','center', 'fontweight','bold','FontSize', label_font)
    text(dff_green_pos(1), dff_rg_pos(2), {'JEDI-1P-Kv', 'channel', '\DeltaF/F_0'}, 'HorizontalAlignment','center', 'fontweight','bold','FontSize', label_font)

    set(gca, 'Visible', 'off')

    title('Example from a lightly anesthetized animal', title_font)  
    set(gcf, 'units', 'centimeters', 'Position',[30,1,14,6]);
    currentDate = string(datetime(date, 'Format', 'yyyyMMdd'));
    imgName = strcat(savePath, filesep, 'Figure4a_', filenamePrefex, 'alinged_traces_', currentDate);

    savefig(imgName)
    saveas(gcf,imgName, 'png')
    saveas(gcf,imgName, 'pdf')

