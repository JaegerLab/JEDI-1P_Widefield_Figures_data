%% Output masked mean fluorescence for each animal

%% Define Paths of Loading Files and Save Files
currentFolder = mfilename('fullpath'); % determine the filepath based on where the script locates
scriptFN = mfilename;
filePath = erase(erase(currentFolder, scriptFN), strcat('scripts', filesep));
searchPath = strcat(filePath, 'data', filesep, 'Figure3f-i');
savePath = strcat(filePath, filesep, 'plots', filesep, 'Figure3f-i', filesep);
searchTerm = 'EMXJ*_metalist_masked_fluorescence_trace_1121_2022.mat';


%% Set up parameters for plotting
axis_font = 7;
legend_font = 7;
label_font = 7;
title_font = 7;
lineWidth = 1;
%% Find the matching trials 

filelist = dir(fullfile(searchPath, '**', searchTerm));
%% Save data from each animal into one file
counter = 1;
meanRawF_JEDI = zeros(4, 3);
meanRawF_mCherry = zeros(4, 3);
for fileN = 1:length(filelist)
    fullFileName = strcat(filelist(fileN).folder, '\', filelist(fileN).name);
    load(fullFileName, 'metaList')

    for trialN = 1:length(metaList)
        trialName = metaList(trialN).imgA_name;
        AnimalID = trialName(1:6);
        
        JEDI_rawF = metaList(trialN).RawFluorescence.green.meanRawF_masked;
        mCherry_rawF = metaList(trialN).RawFluorescence.red.meanRawF_masked;
    
        metaList(trialN).AnimalID = string(AnimalID);
        metaList(trialN).RawF_JEDI = JEDI_rawF;
        metaList(trialN).RawF_mCherry = mCherry_rawF;
    end

    % 1-5 trials are before the first 30 min illumination
    % 6-10 trials are between the two 30 min illumination
    % 11-15 trials are after the second 30 min illumination
    RawF_JEDI = [metaList.RawF_JEDI];
    RawF_mCherry = [metaList.RawF_mCherry];
    blockTrialNum = 5;
    for blockN = 1:3
        trialInd = (5*(blockN-1)+1): 5*(blockN);
    
        if blockN == 1
           baselineF_JEDI =  mean(RawF_JEDI(trialInd));
           baselineF_mCherry = mean(RawF_mCherry(trialInd));
        end
        meanRawF_JEDI(fileN, blockN) = mean(RawF_JEDI(trialInd))/baselineF_JEDI;
        meanRawF_mCherry(fileN, blockN) = mean(RawF_mCherry(trialInd))/baselineF_mCherry;
    end
end

%% Go over each trial to extract AnimalID info and masked rawF

    z = 1.96;
    arraySize = size(meanRawF_JEDI);
    sampleSize_green = arraySize(1);

    arraySize = size(meanRawF_mCherry);
    sampleSize_red = arraySize(1);   
    x = [0,30,60];
    errorbar(x, mean(meanRawF_JEDI), z * std(meanRawF_JEDI)/sqrt(sampleSize_green), ...
        'LineWidth', lineWidth, 'color', [9, 112, 84]/256)
    hold on
    errorbar(x, mean(meanRawF_mCherry), z * std(meanRawF_mCherry)/sqrt(sampleSize_red), ...
        'LineWidth', lineWidth, 'color', 'k')    
    xticks(0:30:60)
    yticks(0:0.5:1.25)    
    
    xlabel('', 'FontSize', label_font)
    ylabel('Normalized intensity', 'FontSize', label_font)
    [lgd, icons, plots, txt] = legend('show', 'FontSize', legend_font);
    lgd.String = {'JEDI-1P-Kv', 'mCherry'};
%     title('Fluorescence change over days', 'FontSize', label_font)
    xlim([-2 60])
    ylim([0, 1.25])
    legend boxoff   
    ax = gca;
    ax.FontSize = axis_font; 
    ax.XRuler.TickLength = [0.06, 0.06];  
    ax.YRuler.TickLength = [0.06, 0.06];  
    ax.LineWidth = 1;
    
    set(gca,'box','off')

    set(gcf,'units', 'centimeters', 'Position',[30,1,4.5,4]);

    imgFN = strcat(savePath, 'Figure3i_photostability_long_exposure');
    saveas(gcf, imgFN, 'png')
    saveas(gcf, imgFN, 'pdf')

