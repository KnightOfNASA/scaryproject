%script plot
clear
close all

cleanfolder = '.\cleanbox data'; %change to the desired folder
cubefolder = '.\cubes data';
list1 = dir(fullfile(cleanfolder, '*.mat')); %find all .mat files
list2 = dir(fullfile(cubefolder, '*.mat'));
listamount = length(list1) + length(list2);

sortList1 = natsortfiles(list1); %sort files by number
sortList2 = natsortfiles(list2);
%%
fig = figure("WindowState","maximized"); %singular plot

for k = [6:10] %input run # here
    if k <=19
      load(fullfile(cleanfolder, sortList1(k).name)); %load matlab data
      [~, runs, ~] = fileparts(sortList1(k).name); 
    else
      load(fullfile(cubefolder, sortList2(k-19).name)); %load matlab data for cubical boxes
      [~, runs, ~] = fileparts(sortList2(k-19).name); 
    end

    %trim data from zeros
    downperc = downsample(percentick, 10);
    downtime = downsample(timearray, 10);
    ickgradient = gradient(downperc*100);
    timegradient = gradient(downtime);
    totalgrad = ickgradient./timegradient;
    cutind = find(totalgrad > 0.1, 1); 
    beginind = find(timearray == downtime(cutind)); 

    %trimmed data
    percentick_f = percentick(beginind:end)*100;
    timearray_f = timearray(beginind:end) - timearray(beginind); 
  
    
    % aveick = movmean(percentick, 5);
    % aveickgrad = gradient(aveick);
    

    
    %percentickrl = smoothdata(percentick_f, 'rloess');
    


    %fig = figure("WindowState","maximized"); uncomment for individual
    %t = tiledlayout(1,1);
    %plots
    % ax1 = axes(t);
    %plot( timearray_f(1:100:end), percentick_f(1:100:end), '*', 'DisplayName',runs);
    scatter(timearray_f(1:100:end), percentick_f(1:100:end),'filled')
    %plot(timearray_f, percentick_f, ':');
    hold on
    %plot( timearray_f,percentickrl, 'LineWidth',1)
    
    %plot(timearray_f, percentickrlw);

    
   

end
grid on 
    
    xlabel('actual time (seconds)', 'FontSize',15)
    ylabel('percent (%)', 'FontSize',15)

    
    % timearrayscale = timearray_f*21.6/60;
    % dummydata = zeros(length(timearrayscale), 1);
    % % ax2 = axes(t);
    % % plot(ax2, timearrayscale, dummydata, 'Color','none')
    % % ax2.XAxisLocation = 'top';
    % % ax2.Color = 'none'; 
    % % ax2.Box = 'off';
    % % ax2.YAxis.Visibl
    ylim([0 100])
    xlim([0 360])
   legend('Run 6', 'Run 7', 'Run  8', 'Run 9', 'Run 10', 'Location','best', 'Interpreter', 'none')
  % runsnew = strcat(runs, ' TEST_2a');
   % title(runs, 'Interpreter','none', 'FontSize',15)
    %saveas(fig, runs, 'png')
    hold off