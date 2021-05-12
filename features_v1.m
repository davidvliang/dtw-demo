%% Clear Workspace
clc;
close all;
clear all;


%% Import Data

load('Data/data.mat')
I1 = data2file(:,1);
Q1 = data2file(:,2);
I2 = data2file(:,3);
Q2 = data2file(:,4);
% CB1 = data2file(:,5);
% CB2 = data2file(:,6);
time = data2file(:,7);


%% Preprocess Data

start = find(time==0, 1);
stop = find(time==500, 1); % define the stopping time (default: 500seconds)
% stop = find(time==time(end),1); % go until end of trace

% splice data based on start/stop points
I1 = I1(start:stop);
Q1 = Q1(start:stop);
I2 = I2(start:stop);
Q2 = Q2(start:stop);
% CB1 = CB1(start:stop);
% CB2 = CB2(start:stop);
time = time(start:stop);


%% EMD

[src1_filtered, k_src1, imf_src1, ~] = filter_by_emd(source1);
[src2_filtered, k_src2, imf_src2, ~] = filter_by_emd(source2);


%% Segmentation

minpeakdist = 200;
minpeakprom = 0.5;

% Source 1
[max1, max1_loc] = findpeaks(src1_filtered, 'MinPeakDistance', minpeakdist, 'MinPeakProminence', minpeakprom);
[min1, min1_loc] = findpeaks(-src1_filtered, 'MinPeakDistance', minpeakdist, 'MinPeakProminence', minpeakprom);

% Source 2
[max2, max2_loc] = findpeaks(src2_filtered, 'MinPeakDistance', minpeakdist, 'MinPeakProminence', minpeakprom);
[min2, min2_loc] = findpeaks(-src2_filtered, 'MinPeakDistance', minpeakdist, 'MinPeakProminence', minpeakprom);

% Line up half-segments
peaks1 = clean_segments(max1, max1_loc, min1, min1_loc);
peaks2 = clean_segments(max2, max2_loc, min2, min2_loc);   

% Plot Peaks
figure(1);
subplot(2,1,1);
hold on;
plot(time(peaks1(:,2)), peaks1(:,1), 'linestyle','none', 'Marker', 'o', 'Color', 'b'); 
plot(time(peaks1(:,4)), peaks1(:,3), 'linestyle','none', 'Marker', 'o', 'Color', 'r'); 
plot(time, src1_filtered, 'Color', 'k');
title('source1');
hold off;
subplot(2,1,2);
hold on;
plot(time(peaks2(:,2)), peaks2(:,1), 'linestyle','none', 'Marker', 'o', 'Color', 'b'); 
plot(time(peaks2(:,4)), peaks2(:,3), 'linestyle','none', 'Marker', 'o', 'Color', 'r'); 
plot(time, src2_filtered, 'Color', 'k');
title('source2');
hold off;


%% DTW



%% Feature Selection



%% Save Features

% save(['fwpt_1_ws', num2str(winsize), '_wi', num2str(wininc), '.mat'], 'fwpt_feat_1');
% save(['fwpt_2_ws', num2str(winsize), '_wi', num2str(wininc), '.mat'], 'fwpt_feat_2');
% save('morph_1.mat', 'morph_feat_1');
% save('morph_2.mat', 'morph_feat_2');


