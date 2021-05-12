clc
clear
% close all

%% **** Load Data
trial = 1; 
freq_vals = [0.2000, 0.2500, 0.3000, 0.3167, 0.3333, 0.3500, 0.3667, 0.4000, 0.4500, 0.5000];

fig1 = figure(3);
clf(3);


for fat_index = 1:length(freq_vals)

% Select Data by parameters 
freq = freq_vals(fat_index); % of 10

belt_data = ['Data/trial' num2str(trial) '/' num2str(freq,'%0.4f') 'Hz_belt_' num2str(trial) '_trial.txt'];
radar_data = ['Data/trial' num2str(trial) '/' num2str(freq,'%0.4f') 'Hz_radar_' num2str(trial) '_trial.csv'];
noise_data = ['Data/trial' num2str(trial) '/0.0000Hz_radar_' num2str(trial) '_trial_background.csv'];


C = readtable(belt_data); % AKA belt/CB/C

B = readtable(radar_data); % AKA radar/binary/B


%% Get RSS, Time, BER, Magnitude, and Phase Data
[Brss, Bt, Bber, Bmag, Bpha] = getInfo2(B);

% convert Bt to relative time
Bt = Bt(:,1) - Bt(1,1); 

[Ct, Cpha] = getInfo3(C);


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


%% Initialize Channel Names
labelArr = strings(32,1);




%% MODIFIED: Plot Phase of CSI for Channels 0 to 31


if ismember(fat_index, 1:5)
    subplot(2,1,1);
    hold on
    grid on
end
if fat_index == 6
    legend('0.2000 Hz', '0.2500 Hz', '0.3000 Hz', '0.3167 Hz', '0.3333 Hz', 'Location', 'southeast');
end

if ismember(fat_index, 6:10)
    subplot(2,1,2);
    hold on
    grid on

end 

ii = 15;
labelArr(ii) = "ch"+(ii-1);
% title(labelArr{ii});
set(gca,'FontSize',12,'Color',[245, 245, 245]/255);
% set(gca, 'Xtick', 0:5:30)
% axis([0 30 -inf inf]);
% xtickangle(90);

% legend([num2str(freq_vals(fat_index)), 'Hz']);


plot(Bt, normalize(unwrap(angle(Bcsi(:,ii)))), 'LineWidth',1);

end
    legend('0.3500 Hz', '0.3667 Hz', '0.4000 Hz', '0.4500 Hz', '0.5000 Hz', 'Location', 'southeast');

%     legend('0.2000 Hz', '0.2500 Hz', '0.3000 Hz', '0.3167 Hz', '0.3333 Hz', 'Location','north');
%     legend('0.3500 Hz', '0.3667 Hz', '0.4000 Hz', '0.4500 Hz', '0.5000 Hz');


% legend([0.2000, 0.2500, 0.3000, 0.3167, 0.3333, 0.3500, 0.3667, 0.4000, 0.4500, 0.5000]);
sgtitle('Phase of CSI for Ch. 14', 'Interpreter', 'None');

% sgtitle(['FFT of Phase of CSI for Trial ', num2str(trial), ' @ ', num2str(freq,'%0.4f'), 'Hz'], 'Interpreter', 'None')
fig = get(groot,'CurrentFigure');
fig.PaperPositionMode = 'auto';
fig.Color = [245, 245, 245]/255;
% fig.Position = get(0, 'Screensize');
% saveas(fig, ['./OUTPUT/Phase_FFT/' 'FFT_PHA_' num2str(freq,'%0.4f') 'Hz_radar_' num2str(trial) '_trial.png'],'png');


helperAdjustFigure(fig1, 'PHA_radar_1_trial')

