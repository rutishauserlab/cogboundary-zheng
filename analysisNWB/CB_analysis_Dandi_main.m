%
% Matlab code to read and plot cognitive boundary data based on NWB-formatted files downloaded from DANDI archive
%
% Pre-requisite: NWB routines are installed and in path and data has been downloaded locally.
% We tested this code with the matnwb 2.4.0 API, running on Matlab 2020b.
%
% Data: https://dandiarchive.org/dandiset/000207/draft
%
% Code by Jie Zheng and Ueli Rutishauser, December 2021
% See paper: Zheng et al. 
%

%% ==== Set paths (modify these three variables for your system)
% This is the path in which the NWB files were downloaded to from DANDI
basepathData = 'C:\projects\DandiDownload\000207';  

% matnwb API. 2.4.0 release of NWB, downloaded from https://github.com/NeurodataWithoutBorders/matnwb/releases/tag/v2.4.0.0
basePathNWBCode = 'C:\svnwork\matnwb-2.4.0.0';

% where this code is checked out to
basePathCode = 'C:\svnwork\cogboundary-zheng.git\trunk\';

%% ==== Initialize NWB
if exist([basePathNWBCode, filesep, '+types', filesep, '+core', filesep, 'NWBFile.m'])
     disp(['generateCore() already initialized...']) %only need to do once
else 
    cd([basePathNWBCode])
    generateCore();
    disp(['generateCore() initialized...'])
end 

addpath(basePathNWBCode); 
addpath([basePathCode filesep 'analysisNWB' ]);
addpath([basePathCode filesep 'analysisNWB' filesep 'helpers']);

%% Open NWB file for one session and plot all cells
%== Parameters for analysis
CBID_toPlot = 4;   % Which Subject to plot (CBID)
plotMode = 1;      % what to plot. 1=encoding, boundary aligned, 2=encoding, stim onset aligned. 3=recognition test, stim onset aligned. 4=time order test, stim onset aligned.

%===== no parameters below this
% which session to analyze
fName_in = ['sub-' num2str(CBID_toPlot) filesep 'sub-' num2str(CBID_toPlot) '_ses-' num2str(CBID_toPlot) '_ecephys+image.nwb'];

% import file
disp(['Opening: ' fName_in]);
nwbData = nwbRead([basepathData filesep fName_in]);

% load neural data from NWB data structures
all_spike_data = nwbData.units.spike_times.data.load();
spike_data_indexes = nwbData.units.spike_times_index.data.load();
channel_ids_index = nwbData.general_extracellular_ephys_electrodes.vectordata.get('origChannel').data.load();
cell_electrodes = nwbData.units.electrodes.data.load();
brain_areas_index = nwbData.general_extracellular_ephys_electrodes.vectordata.get('location').data.load;
clusterIDs = nwbData.units.id.data.load;   %all available id's (clusters)
elec_index = [nwbData.units.electrodes.data.load()]+1;
channel_ids = channel_ids_index(elec_index);
brain_areas = brain_areas_index(elec_index,:);

bin_width_raster = 0.01; % 10ms per bin
bin_width_fr = 0.2; % 200ms per bin
plot_flag = 'on';

%loop over all cells in this session
%for i = 1:2  %only subset
for i = 1:length(clusterIDs)   %All cells
    
    %== locate spikes that belong to this cluster
    timestampsOfCell = nwb_read_unit(nwbData.units.spike_times_index, nwbData.units.spike_times, clusterIDs(i)+1 );
    channelid =  channel_ids(i);
    cellNr = clusterIDs(i);
    brainAreaOfCell = brain_areas(i,:);
    currentCell = cellNr;
    
    %== plot this cell
    switch(plotMode)
        case 1
            %encoding, boundary aligned
            B01_raster_psth_encoding_BAligned_BSep_NWB(  nwbData, timestampsOfCell, channelid, cellNr, brainAreaOfCell, bin_width_raster, bin_width_fr, plot_flag);
        case 2
            %encoding, stim onset aligned
            B01_raster_psth_encoding_SAligned_BSep_NWB(  nwbData, timestampsOfCell, channelid, cellNr, brainAreaOfCell, bin_width_raster, bin_width_fr, plot_flag);
        case 3
            %recog, stim onset aligned
            B01_raster_psth_sceneRecog_SAligned_BSep_NWB(  nwbData, timestampsOfCell, channelid, cellNr, brainAreaOfCell, bin_width_raster, bin_width_fr, plot_flag);
        case 4
            %timeDiscr, stim onset aliged
            B01_raster_psth_timeDiscrim_SAligned_BSep_NWB(  nwbData, timestampsOfCell, channelid, cellNr, brainAreaOfCell, bin_width_raster, bin_width_fr, plot_flag);
        otherwise
            error('unknown plot mode');
    end
end
