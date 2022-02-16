%
% Plots response of cells during encoding, aliged to stimulus onset
%
%History
%12/2/21: This file is forked from original B01_raster_psth_encoding_BAligned_BSep.m by JZ.
%
function [] = B01_raster_psth_encoding_SAligned_BSep_NWB(nwbData, timestampsOfCell, channelid, cellNr, brainAreaOfCell, bin_width_raster, bin_width_fr, plot_flag)

%% prepare interval data (encoding period)
%=== load data from the interval table
encoding_table = nwbData.intervals.get('encoding_table');

ttls_clip_onsets = encoding_table.start_time.data.load();  % TTL=1
stimCategory = encoding_table.vectordata.get('stimCategory').data.load();  % NB, SB, HB

%=== convert relative boundary times to absolute times by adding start of each video
indxNB = ( stimCategory==0);
indxSB = ( stimCategory==1);
indxHB = ( stimCategory==2);

%% prepare spiking data
baseline_duration = floor(0.5/bin_width_raster);
trial_duration = floor(1/bin_width_raster);

bins_n_raster = baseline_duration + trial_duration;
spks_per_trial = zeros(135, bins_n_raster);
for n_trial = 1:90
    lower_limit = ttls_clip_onsets(n_trial)-0.5;
    upper_limit = ttls_clip_onsets(n_trial)+ 1;
    spk_indx = (timestampsOfCell > lower_limit) & (timestampsOfCell < upper_limit);
    spk_selected = timestampsOfCell(spk_indx);
    spk_selected_bin = ceil((spk_selected - lower_limit)./(bin_width_raster));
    spks_per_trial(n_trial, spk_selected_bin) = 1;
end

%% plot

subjectID = nwbData.general_session_id; %CBID

cellLabelStr = ['NWB ' subjectID '-' num2str(channelid) '-' num2str(cellNr) '-' brainAreaOfCell{1} ];

[xpoints_NB,ypoints_NB] = find(spks_per_trial(indxNB,:) == 1); % NB
[xpoints_SB,ypoints_SB] = find(spks_per_trial(indxSB,:) == 1); % SB
[xpoints_HB,ypoints_HB] = find(spks_per_trial(indxHB,:) == 1); % HB

HB_color = [255,99,71]./255;
SB_color = [100,149,237]./255;
NB_color = [102 204 0]./255;
fig = figure('rend','painters','pos',[10 10 400 700], 'visible', plot_flag);
h_raster = subplot(2,1,1);
ax_raster = get(h_raster,'Position');
ax_raster(4) = ax_raster(4)+0.1;
ax_raster(2) = ax_raster(2)-0.12;
set(h_raster, 'Position', ax_raster);
scatter(ypoints_NB, xpoints_NB-min(xpoints_NB)+61, 1, 'MarkerEdgeColor', NB_color, 'MarkerFaceColor', NB_color, 'LineWidth', 1); hold on
scatter(ypoints_SB, xpoints_SB-min(xpoints_SB)+31, 1, 'MarkerEdgeColor', SB_color, 'MarkerFaceColor', SB_color, 'LineWidth', 1);
scatter(ypoints_HB, xpoints_HB-min(xpoints_HB)+1, 1, 'MarkerEdgeColor', HB_color, 'MarkerFaceColor', HB_color, 'LineWidth', 1);
plot([0.5/bin_width_raster 0.5/bin_width_raster], [0 135], 'k--', 'LineWidth', 2);
xlim([0 baseline_duration + trial_duration])
ylim([0 90])
xlabel('Time (seconds)')
ylabel('Trial number')
set(gca, 'LineWidth', 1.5, 'XTick', 1/bin_width_raster*[0 0.5 1.5], 'XTickLabel', [-0.5 0 1],...
    'fontsize', 15, 'fontweight', 'bold','box','on')
% generate firing rate plots, 200ms window
n_data = (bin_width_fr/bin_width_raster); % number of data per window
fr_per_bin_HB = smoothdata(spks_per_trial(61:90,:),2, 'gaussian',n_data)*n_data;  % convert it to Hz
fr_per_bin_SB = smoothdata(spks_per_trial(31:60,:),2, 'gaussian',n_data)*n_data;  % convert it to Hz
fr_per_bin_NB = smoothdata(spks_per_trial(1:30,:),2, 'gaussian',n_data)*n_data;  % convert it to Hz
fr_per_bin_avg_HB = mean(fr_per_bin_HB,1);
fr_per_bin_avg_SB = mean(fr_per_bin_SB,1);
fr_per_bin_avg_NB = mean(fr_per_bin_NB,1);
h_psth = subplot(2,1,2);
ax_psth = get(h_psth,'Position');
ax_psth(4) = ax_psth(4)-0.1;
ax_psth(2) = ax_psth(2)-0.01;
set(h_psth, 'Position', ax_psth);
boundedline(1:bins_n_raster,fr_per_bin_avg_HB , std(fr_per_bin_HB,1)./sqrt(30),'cmap',HB_color,'alpha'); hold on
boundedline(1:bins_n_raster,fr_per_bin_avg_SB , std(fr_per_bin_SB,1)./sqrt(75),'cmap',SB_color,'alpha');
boundedline(1:bins_n_raster,fr_per_bin_avg_NB , std(fr_per_bin_NB,1)./sqrt(30),'cmap',NB_color,'alpha');
plot([0.5/bin_width_raster 0.5/bin_width_raster], [0 135],'k--','LineWidth',2); % the trial onset
xlim([0 baseline_duration + trial_duration])
ylim([0 max([fr_per_bin_avg_HB, fr_per_bin_avg_SB, fr_per_bin_avg_NB]+2)])
xlabel('Time (seconds)')
ylabel('Firing rate (Hz)')
set(gca, 'LineWidth', 1.5, 'XTick', 1/bin_width_raster*[0 0.5 1.5], 'XTickLabel', [-0.5 0 1],...
    'fontsize', 15, 'fontweight', 'bold','box','on')

title(cellLabelStr, 'Interpreter', 'none');

%==uncomment to export figs to 
% figure_dir = [pwd, '/NWB/exported/Figures/CBID', num2str(subjectID), '/SAligned_encoding/'];
% if ~exist(figure_dir)
%     mkdir(figure_dir)
% end
% 
% figure_name = ['Raster_psth_SAligned', cellLabelStr, '_encoding.png'];
% print(fig,'-dpng',[figure_dir,'/', figure_name]);
% close(fig)
% 
