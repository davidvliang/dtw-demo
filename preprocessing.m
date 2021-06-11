%% Clear Workspace
clc;
close all;
clear all;

%% **** Load Data
trial = 1; 
freq_vals = [0.2000, 0.2500, 0.3000, 0.3167, 0.3333, 0.3500, 0.3667, 0.4000, 0.4500, 0.5000];


%% Initialize Information
labelArr = strings(32,1); % Channel Names
scores = zeros([10,32]); % Sensitivity Scores

for freq_index = 1:length(freq_vals)


% Select Data by parameters 
freq = freq_vals(freq_index); % of 10

radar_data = ['Data/exp_2021_04_15/RADAR/' num2str(freq,'%0.4f') 'Hz_radar_' num2str(trial) '_trial.csv'];

B = readtable(radar_data); % AKA radar/binary/B


%% Get RSS, Time, BER, Magnitude, and Phase Data
[~, Bt, ~, Bmag, Bpha] = getRadarInfo(B);

% convert Bt to relative time
Bt = Bt(:,1) - Bt(1,1); 


%% Get CSI for Data Set c
c = 1;
Bcsi = Bmag .* exp(1i.*Bpha);

for ii = 1:32
    if ii == 32
        Bcsi(:,ii) = 1 ./ Bcsi(:,ii);
    else
        Bcsi(:,ii) = 1 ./ ((Bcsi(:,ii+1)-Bcsi(:,ii))/5 * c + Bcsi(:,ii));
    end
end


%% EMD

figure(freq_index);
clf(freq_index);

for ii=1:32
    [Bpha_filtered, k_Bpha, imf_Bpha, ~] = filter_by_emd(normalize(unwrap(angle(Bcsi(:,ii)))));


    %% Compute Periodicity and Sensitivity (verify formulas are correct)
    periodicity = max(pwelch(Bpha_filtered)) / mean(pwelch(Bpha_filtered));
    sensitivity = sum((Bpha_filtered - mean(Bpha_filtered)).^2 / length(Bpha_filtered));
    scores(freq_index, ii) = 100 / (periodicity + sensitivity);
    
    %% Plot EMD

    subplot(8,4,ii);
    hold on
    grid on
%     labelArr(ii) = "ch"+(ii-1);
    labelArr(ii) = "ch"+(ii-1)+" score="+scores(freq_index, ii)+" k="+k_Bpha+"/"+size(imf_Bpha,2);

    title(labelArr{ii});
    set(gca,'FontSize',12,'Color',[245, 245, 245]/255);
    set(gca, 'Xtick', 0:5:120);
    axis([0 120 -inf inf]);
    xtickangle(90);
    
    
    plot(Bt, normalize(unwrap(angle(Bcsi(:,ii)))), 'k','LineWidth',1); % unfiltered    
    plot(Bt, Bpha_filtered, 'r','LineWidth',1); % filtered    


    
end

sgtitle(['Filtered Phase of CSI vs. Time (s) for Trial ', num2str(trial), ' @ ', num2str(freq,'%0.4f'), 'Hz'], 'Interpreter', 'None')
fig = get(groot,'CurrentFigure');
fig.PaperPositionMode = 'auto';
fig.Color = [245, 245, 245]/255;
fig.Position = get(0, 'Screensize');
% saveas(fig, ['Images/EMD/' 'EMD_PHA_' num2str(freq,'%0.4f') 'Hz_radar_' num2str(trial) '_trial.png'],'png');



end

%% Subcarrier Selection 

[max_score, max_ch] = max(scores, [], 2);

for freq_index = 1:length(freq_vals)


% Select Data by parameters 
freq = freq_vals(freq_index); % of 10

radar_data = ['Data/exp_2021_04_15/RADAR/' num2str(freq,'%0.4f') 'Hz_radar_' num2str(trial) '_trial.csv'];

B = readtable(radar_data); % AKA radar/binary/B


%% Get RSS, Time, BER, Magnitude, and Phase Data
[~, Bt, ~, Bmag, Bpha] = getRadarInfo(B);

% convert Bt to relative time
Bt = Bt(:,1) - Bt(1,1); 


%% Get CSI for Data Set c
c = 1;
Bcsi = Bmag .* exp(1i.*Bpha);

for ii = 1:32
    if ii == 32
        Bcsi(:,ii) = 1 ./ Bcsi(:,ii);
    else
        Bcsi(:,ii) = 1 ./ ((Bcsi(:,ii+1)-Bcsi(:,ii))/5 * c + Bcsi(:,ii));
    end
end







end


% figure(length(freq_vals)+1);
% clf(length(freq_vals)+1);
% legend
% hold on
% grid on
% 
% set(gca,'FontSize',12,'Color',[245, 245, 245]/255);
% % set(gca, 'Xtick', 0:5:30)
% % axis([0 30 -inf inf]);
% % xtickangle(90);
% 
% % legend([num2str(freq_vals(fat_index)), 'Hz']);
% 
% plot(Bt, Bpha_filtered, 'LineWidth', 1, 'DisplayName', [num2str(freq,'%0.4f') 'Hz @ ch' num2str(max_ch-1)]);
% hold on
% 
% 



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


