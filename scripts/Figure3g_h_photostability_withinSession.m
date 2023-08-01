%% Plot Figure g and h

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure3f-i');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure3f-i', filesep);
searchTerm = '*fluorescence_trace_0801_2022.mat';
%% Set up the parameters
duration = 20.48;
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 0.5;

%% Load data from EMXJ7-9 10 Sesions each
    subjectNumbers = {'7', '8', '9'};
    output_Names = strcat('output_J', subjectNumbers);
    %% Load the files 
    [output_J7] = loadIntensityData("EMXJ7", searchPath, searchTerm);
    [output_J8] = loadIntensityData("EMXJ8", searchPath, searchTerm);
    [output_J9] = loadIntensityData("EMXJ9", searchPath, searchTerm);
    
    %% Combine data from all three animals
    % plot normalized RawF from three mice    
    % overlay with mean value with standard deviation
    x = 1:2:20;
    normalizedRawF_green = [output_J7.normalizedRawF_green;...
        output_J8.normalizedRawF_green;...
        (output_J9.normalizedRawF_green)];
    
    normalizedRawF_red = [output_J7.normalizedRawF_red;...
        output_J8.normalizedRawF_red;...
        output_J9.normalizedRawF_red];

%% Combine data from all three animals for data within a session
%Remove session without 100 trials, 3 sessions did not have full 100 trials
%due to technical issuee during recording

    individualSessionRawF_green =[{output_J7.individualSessions.normalized_green},...
        {output_J8.individualSessions.normalized_green},...
        {output_J9.individualSessions.normalized_green}];
    
    individualSessionRawF_red =[{output_J7.individualSessions.normalized_red},...
        {output_J8.individualSessions.normalized_red},...
        {output_J9.individualSessions.normalized_red}];
    
    % remove sessions that does not have 100 trials
    individualSessionRawF_green(cellfun('length',individualSessionRawF_green)~=100) = [];
    individualSessionRawF_red(cellfun('length',individualSessionRawF_red)~=100) = [];
    
    groupRawF_green = cat(1,individualSessionRawF_green{:});
    groupRawF_red = cat(1,individualSessionRawF_red{:});

figure    
    [lineOut, fillOut] = CIshade_methods(groupRawF_green, 0.1, [9, 112, 84]/256, [], [], '-');
    sampleSize = size(groupRawF_green);
    sampleSize = sampleSize(1);
    SEM = std(groupRawF_green)/sqrt(sampleSize); 
    CI_95_panel2 = 1.96 * SEM;
    hold on
    xlabel('Trial number within a session', 'FontSize', label_font)
    ylabel('Mean normalized intensity', 'FontSize', label_font) 
    legend('', 'JEDI-1P-Kv', 'FontSize', legend_font) 

    legend boxoff
    xlim([0, 100])
    yticks(0:0.5:1.25)
    ylim([0, 1.25])
    ax = gca;
    ax.FontSize = axis_font; 
    ax.XRuler.TickLength = [0.06, 0.06];
    ax.YRuler.TickLength = [0.06, 0.06];

    ax.LineWidth = 1;
    set(gca,'box','off')
    set(gcf,'units', 'centimeters', 'Position',[30,1,4.5,4]);

imgName = strcat(savePath, '\Figure3g_photostability_withinSession');
savefig(imgName)
saveas(gcf,imgName, 'png')   
saveas(gcf,imgName, 'pdf') 

%% Plot average change during a session 
figure    
    z = 1.96;
    arraySize = size(normalizedRawF_green);
    sampleSize_green = arraySize(1);

    arraySize = size(normalizedRawF_red);
    sampleSize_red = arraySize(1);    
    errorbar(x, mean(normalizedRawF_green), z * std(normalizedRawF_green)/sqrt(sampleSize_green), ...
        'LineWidth', lineWidth, 'color', [9, 112, 84]/256)
    hold on
    errorbar(x, mean(normalizedRawF_red), z * std(normalizedRawF_red)/sqrt(sampleSize_red), ...
        'LineWidth', lineWidth, 'color', 'k')    
    
    
    xlabel('Day', 'FontSize', label_font)
    ylabel('Normalized intensity', 'FontSize', label_font)
    [lgd, icons, plots, txt] = legend('show', 'FontSize', legend_font);
    lgd.String = {'JEDI-1P-Kv', 'mCherry'};

    xticks(1:5:20)
    yticks(0:0.5:1.25)
    xlim([0, 20])
    ylim([0, 1.25])
    legend boxoff   
    ax = gca;
    ax.FontSize = axis_font; 
    ax.XRuler.TickLength = [0.06, 0.06];  
    ax.YRuler.TickLength = [0.06, 0.06];  
    ax.LineWidth = 1;
    set(gca,'box','off')

set(gcf,'units', 'centimeters', 'Position',[30,1,4.5,4]);


imgName = strcat(savePath, '\Figure3g_photostability_MultipleSessions');
savefig(imgName)
saveas(gcf,imgName, 'png')   
saveas(gcf,imgName, 'pdf') 


function [output] = loadIntensityData(AnimalID, searchPath, searchTerm)
searchTerm = strcat(AnimalID, searchTerm);
metaLists = dir(fullfile(searchPath, '**', searchTerm));

%% Calulate light intensity & Concatenate metalist

%background Fluorescence
backgroundF_g = 590;
backgroundF_r = 276;

% calculate mean raw light intensity of each session
% concatenate the metalist into one
output = struct;
meanRawF_masked_red = zeros(1, length(metaLists));
meanRawF_masked_green = zeros(1, length(metaLists));
individualSession = struct('normalized_red', cell(1, length(metaLists)));
for listN = 1:length(metaLists)
    load(strcat(metaLists(listN).folder, '\', metaLists(listN).name), 'metaList')
    RawF_masked_red = arrayfun(@(x) x.RawFluorescence.red.meanRawF_masked, metaList);
    RawF_masked_green = arrayfun(@(x) x.RawFluorescence.green.meanRawF_masked, metaList);

    meanRawF_masked_red(listN) = mean(RawF_masked_red);
    meanRawF_masked_green(listN) = mean(RawF_masked_green);
    
    RawF_masked_red = RawF_masked_red - backgroundF_r;
    RawF_masked_green = RawF_masked_green - backgroundF_g;
    
    individualSession(listN).normalized_red = RawF_masked_red /RawF_masked_red(1);
    individualSession(listN).normalized_green = RawF_masked_green/RawF_masked_green(1);
    
    if listN == 1
        megaList = metaList;
    else
        megaList = [megaList, metaList];
    end
end

% calculate percentage of change for each session
meanRawF_masked_green = meanRawF_masked_green - backgroundF_g;
meanRawF_masked_red = meanRawF_masked_red -  backgroundF_r;
normalizedRawF_red = meanRawF_masked_red/meanRawF_masked_red(1);
normalizedRawF_green = meanRawF_masked_green/meanRawF_masked_green(1);

% plot the change for each trial
RawF_masked_red_allTrials = arrayfun(@(x) x.RawFluorescence.red.meanRawF_masked, megaList); 
RawF_masked_green_allTrials = arrayfun(@(x) x.RawFluorescence.green.meanRawF_masked, megaList); 

output.meanRawF_masked_red = meanRawF_masked_red;
output.meanRawF_masked_green = meanRawF_masked_green;
output.normalizedRawF_red = normalizedRawF_red;
output.normalizedRawF_green = normalizedRawF_green;
output.RawF_masked_red_allTrials = RawF_masked_red_allTrials;
output.RawF_masked_green_allTrials = RawF_masked_green_allTrials;
output.individualSessions = individualSession;
end