
%batch frame code
%split videos into frames, dewrap, and crop them
%this is to enable the use of parallel toolbox on the frames directly, as
%videoreader does not support parallel computing
%this speeds up the computation time, although for large and numerous
%files, it can still take a week!
%%
close all; 
clear; 
camcalibparam; %run script for camera parameters
sourceDir = 'E:\Covid19\videos'; %source director of the files
%extract video
clearBox = fullfile(sourceDir, '\ClearBox');
officeBox = fullfile(sourceDir, '\Cubicals');
list1 = dir(fullfile(clearBox, '*.avi')); %extracts all avi files 
numFile1 = length(list1); %count number of videos
sortF1 = natsortfiles(list1); 

list2 = dir(fullfile(officeBox, '*.avi'));
numFile2 = length(list2);
sortF2 = natsortfiles(list2); 

%recommend checking what file names are stored in the variable by running
%this section first before continuing to next part of the script. 

recout = [ 486.5100   68.5100  943.9800  964.9800]; %crop rectangle. Recommend using imcrop
%to get the cropping dimension first, then store the dimension on a
%variable. 

%% 
%clearbox 
for n = 1:numFile1 %if interrupted, change n to desired number
     currentTitle = fullfile(sourceDir, '\ClearBox', sortF1(n).name); %extract current video title
     currentVideo = VideoReader(currentTitle); 
     numFrames = currentVideo.NumFrames;

     [~, runs, ~] = fileparts(sortF1(n).name); 
      runnum = textscan(runs, '%*s %f %f', 'Delimiter', '_');

    if runnum{2} == 2023
        runtitle = strcat("Run", "_", num2str(runnum{1}));
    else
        runtitle = strcat("Run", "_", num2str(runnum{1}), "_", num2str(runnum{2}));
    end

    %make folder here
    foldername = fullfile(clearBox, runtitle);
    % mkdir(foldername);


    %do frame dewrap operation
    for k = 1:numFrames
        frame = read(currentVideo, k); %extract current frame
        [~, cropframe] = grayhueframe(frame, cameraParams, recout);
        names = sprintf('%04d.png', k);
        imwrite(cropframe, fullfile(foldername, names));
    end

    
end


%%
%office boxes
for m = 1:numFile2
    currentTitle = fullfile(sourceDir, '\Cubicals', sortF2(m).name); %extract current video title
     currentVideo = VideoReader(currentTitle); 
     numFrames = currentVideo.NumFrames;

     [~, runs, ~] = fileparts(sortF2(m).name); 
      runnum = textscan(runs, '%*s %f %f', 'Delimiter', '_');

    if runnum{2} == 2023
        runtitle = strcat("Run", "_", num2str(runnum{1}));
    else
        runtitle = strcat("Run", "_", num2str(runnum{1}), "_", num2str(runnum{2}));
    end

    %make folder here
    foldername = fullfile(officeBox, runtitle);
     mkdir(foldername);


    %do frame dewrap operation
    for k = 1:numFrames
        frame = read(currentVideo, k); %extract current frame
        [~, cropframe] = grayhueframe(frame, cameraParams, recout);
        names = sprintf('%04d.png', k);
        imwrite(cropframe, fullfile(foldername, names));
    end

end

