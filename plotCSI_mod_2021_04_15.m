clc
clear
% close all

%% **** Load Data
trial = 1; 
freq_vals = [0.2000, 0.2500, 0.3000, 0.3167, 0.3333, 0.3500, 0.3667, 0.4000, 0.4500, 0.5000];


for freq_index = 1:length(freq_vals)

% Select Data by parameters 
freq = freq_vals(freq_index); % of 10

radar_data = ['Data/exp_2021_04_15/RADAR/' num2str(freq,'%0.4f') 'Hz_radar_' num2str(trial) '_trial.csv'];

B = readtable(radar_data); % AKA radar/binary/B


%% Get RSS, Time, BER, Magnitude, and Phase Data
[Brss, Bt, Bber, Bmag, Bpha] = getRadarInfo(B);

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


%% Initialize Channel Names
labelArr = strings(32,1);


%% Plot Phase of CSI for Channels 0 to 31

figure(freq_index);
clf(freq_index);

for ii=1:32
    subplot(8,4,ii);
    hold on
    grid on
    labelArr(ii) = "ch"+(ii-1);
    title(labelArr{ii});
    set(gca,'FontSize',12,'Color',[245, 245, 245]/255);
    set(gca, 'Xtick', 0:5:120);
    axis([0 120 -inf inf]);
    xtickangle(90);
    
    plot(Bt, normalize(unwrap(angle(Bcsi(:,ii)))), 'k','LineWidth',1);
    
end

sgtitle(['Phase of CSI vs. Time (s) for Trial ', num2str(trial), ' @ ', num2str(freq,'%0.4f'), 'Hz'], 'Interpreter', 'None')
fig = get(groot,'CurrentFigure');
fig.PaperPositionMode = 'auto';
fig.Color = [245, 245, 245]/255;
fig.Position = get(0, 'Screensize');
saveas(fig, ['Images/Phase/' 'PHA_' num2str(freq,'%0.4f') 'Hz_radar_' num2str(trial) '_trial.png'],'png');


end
