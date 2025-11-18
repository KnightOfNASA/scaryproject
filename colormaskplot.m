clc; 
close all; 
clear; 

cluster = parcluster;
frameRate = 21.6;
timecount = inv(frameRate);

sourceDir = 'E:\Covid19\videos';
clearBox = fullfile(sourceDir, '\ClearBox');

Runlist = dir(fullfile(clearBox, 'Frames'));
numRun = length(Runlist);

%%
figure

for n = 3:numRun %skipping ., .. 
    list = dir(fullfile(Runlist(n).folder, Runlist(n).name, '*.png'));
    numFile = length(list);
    areaframe = imread(fullfile(list(1).folder, list(1).name));
    area = numel(areaframe(:,:,1));
    
    percentick = zeros(1,numFile);


    parfor k = 1:numFile
        currentFrame = imread(fullfile(list(k).folder, list(k).name));
        [~, maskedFrame] = createMask(currentFrame);
        brightFrame = imlocalbrighten(maskedFrame);
        hueFrame = rgb2hsv(brightFrame);
        satFrame = hueFrame(:,:,2);
        dSatFrame = medfilt2(satFrame, [3 3], 'symmetric');
        bwFrame = imbinarize(dSatFrame, 0.3);
        percentick(k) = sum(bwFrame(:))/area;
    end

    timearray = (1:numFile)*timecount; 
    
    runsfile = strcat(Runlist(n).name, '.mat');
    save(runsfile, 'timearray', 'percentick');

    plot(timearray, percentick, 'DisplayName',Runlist(n).name);
    hold on

end

grid on
title('Color Mask Test Plot for Clean Box')
xlabel('Time (s)')
ylabel("Percent Spread")
lgd = legend;
lgd.Interpreter = "none";
lgd.Location = "best";
