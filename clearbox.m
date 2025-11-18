%clear box extraction %OBSELETE
clc; 
close all; 
clear; 
camcalibparam; %run script for camera parameters
sourceDir = 'E:\Covid19\videos';
%%
clearBox = fullfile(sourceDir, '\ClearBox', '*.avi');
list = dir(clearBox); %extracts all avi files 

numFile = length(list); %count number of videos
sortF = natsortfiles(list); 



%%
for n = 3
    currentTitle = fullfile(sourceDir, '\ClearBox', sortF(n).name); %extract current video title
    currentVideo = VideoReader(currentTitle); 
    [~, runs, ~] = fileparts(sortF(n).name); 
    runnum = textscan(runs, '%*s %f %f', 'Delimiter', '_');

    if runnum{2} == 2023
        runtitle = strcat("Run", "_", num2str(runnum{1}));
    else
        runtitle = strcat("Run", "_", num2str(runnum{1}), "_", num2str(runnum{2}));
  
    end


    numFrames = currentVideo.NumFrames;
    frameRate = currentVideo.FrameRate;
    timecount = inv(frameRate);

    background = read(currentVideo, 1);
    backframe = grayhueframe(background, cameraParams, recout);
    area = numel(backframe); %calculate area of the video 
    currenttime = timecount; %seconds
    timearray = zeros(numFrames, 1);
    timearray(1) = currenttime; %store time
    percentick = zeros(numFrames, 1); %always starts out unsick

    videoname = strcat(runtitle,"_hue");

    v = VideoWriter(videoname);
    open(v);



    for k = 1:numFrames %do this for every frame in the video
        frame = read(currentVideo, k); %extract current frame
        [midframe, cropframe] = grayhueframe(frame, cameraParams, recout);
        filtframe = subframe(midframe, backframe);
    
        % intensity > 20 = dye, intensity < 20 = background
        %do intensity calculations
       % threshL = interp1([0 255], [0, 1], 22);
        threshL = 0.4;
        bw = imbinarize(filtframe, threshL);
        bw2 = bwareaopen(bw, 10);
        spread = sum(bw2(:)); %number of pixels that got the ick
        timearray(k) = currenttime + k*currenttime; 
        percentick(k) = spread/area; 

        % bwframe = im2uint8(bw);
        % 
        compframe = imfuse(cropframe, bw2);
        writeVideo(v, compframe);
       
    end
    % percenticks = smooth(percentick);
    % percentickmean = smoothdata(percentick, 'movmean');
    % percentickgauss = smoothdata(percentick, 'gaussian');
    % percentickrlw = smoothdata(percentick, 'rlowess');
    % percentickrl = smoothdata(percentick, 'rloess');
    
    % 
    plot(timearray, percentick);
    % hold on
    % plot(timearray, percenticks);
    % hold on
    % plot(timearray, percentickmean);
    % hold on 
    % plot(timearray, percentickgauss);
    % hold on
    % plot(timearray, percentickrlw);
    % hold on
    % plot(timearray, percentickrl);
    

    hold on
    runsfile = strcat(runtitle, '.mat');
    save(runsfile, 'timearray', 'percentick');
    close(v);

end
grid on
xlabel('time elapsed (s)')
ylabel('spread percentage')
title('Clear Box Spread sat channel test run 3')
% legend('original', 'smooth', 'movmean', 'gaussian', 'rlow', 'rlo')
% 
% hold off



