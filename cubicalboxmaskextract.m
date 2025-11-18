%this script use colormask function in matlab to identify dye and export
%dyed percentage
%createMask is created by visual toolbox color mask app.
%parallel toolbox is used to speed up application of the pixel counter
%this code can run for a day for large files! 

clc; 
close all; 
clear; 

cluster = parcluster;
frameRate = 21.6;
timecount = inv(frameRate); %used for time counter

sourceDir = 'E:\Covid19\videos'; %location of the frame fies
officeBox = fullfile(sourceDir, '\Cubicals');

Runlist = dir(fullfile(officeBox, 'Frames'));
numRun = length(Runlist);

%%
figure

for n = 3:numRun %numRun %skipping ., .. by starting at 3. change number if you want a specific folder
    list = dir(fullfile(Runlist(n).folder, Runlist(n).name, '*.png'));
    numFile = length(list);
    areaframe = imread(fullfile(list(1).folder, list(1).name));
    area = numel(areaframe(:,:,1)); %calculate the area of the frame
    
    percentick = zeros(1,numFile);


    parfor k = 1:numFile %imread is supported by parfor
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
    save(runsfile, 'timearray', 'percentick'); %store percentage data in a
    % mat file for easier access later on. their corresponding time is
    % saved

    plot(timearray, percentick, 'DisplayName',Runlist(n).name); %for error checking
    % in the process. If this looks bad, change the createMask parameter by
    % using the color thresholder and recreate createMask function
    hold on

end

grid on
title('Color Mask Test Plot for Cubical Box')
xlabel('Time (s)')
ylabel("Percent Spread")
lgd = legend;
lgd.Interpreter = "none";
lgd.Location = "best";
