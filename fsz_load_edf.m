function [EEG,HDR] = fsz_load_edf(filepath)


hdr = ft_read_header(filepath); 
dat = ft_read_data(filepath); 

chanlist = {'Fp1', 'F3', 'C3', 'P3', 'O1', ...
            'Fp2', 'F4', 'C4', 'P4', 'O2', ...
            'F7', 'C5', 'P7', 'F8', 'C6', 'P8', ...
            'Fz', 'Cz', 'Pz', 'Oz'};
        
for c = 1:length(chanlist)
    cid(c) = find(strcmp(hdr.label, chanlist{c})); 
end
dat  = dat - mean(dat,2); 
filt = ft_preproc_bandpassfilter(dat(cid,:), hdr.Fs, [0.1, 120], 32, 'fir'); 
filt = ft_preproc_bandstopfilter(dat(cid,:), hdr.Fs, [48, 52], 64, 'firls', 'twopass'); 

% Plot example EEG
%--------------------------------------------------------------------------
for c = 1:length(cid)
    plot(filt(c,:) - 1000*c, 'color', [.2 .2 .2])    
    hold on
end
set(gca, 'Ytick', [-length(cid):-1]*1000); 
set(gca, 'Yticklabel', flip(chanlist));
ylim([(-length(cid)-1)*1000, 0]); 

HDR.Fs      = hdr.Fs; 
HDR.T0      = hdr.orig.T0; 
HDR.label   = chanlist; 
EEG         = filt;