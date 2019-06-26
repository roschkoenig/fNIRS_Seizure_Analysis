% fsz - fNIRS seizure analysis

% Housekeeping
%==========================================================================
fs  = filesep; 
F   = fsz_org_housekeeping;

%% Load fNIRS data and convert to normalised regressors
%==========================================================================
fnirs = fsz_load_fnirs([F.data fs 'fNIRS.xlsx']); 
fcomp = fsz_pca_comp(fnirs, {'L','R'}, {'hbr', 'cco'}); 

%% Load EEG and convert to time-frequency MEEG files
%==========================================================================
hdr = ft_read_header([F.data fs 'EEG.EDF']); 
dat = ft_read_data([F.data fs 'EEG.EDF']); 

chanlist = {'Fp1', 'F3', 'C3', 'P3', 'O1', ...
            'Fp2', 'F4', 'C4', 'P4', 'O2', ...
            'F7', 'C5', 'P7', 'F8', 'C6', 'P8', ...
            'Fz', 'Cz', 'Pz', 'Oz'};
        
for c = 1:length(chanlist)
    cid(c) = find(strcmp(hdr.label, chanlist{c})); 
end
dat  = dat - mean(dat,2); 
filt = ft_preproc_bandpassfilter(dat(cid(c),:), hdr.Fs, [0.1, 120], 8, 'fir'); 
filt = ft_preproc_bandstopfilter(dat(cid(c),:), hdr.Fs, [49, 51], 8, 'fir'); 

%%
for c = 1:length(cid)
    plot(filt + 250*c)
    hold on
end
% Convert EEG data to time-frequency MEEG files

% Run SPM to identify scalp correlates of fNIRS regressors 