function D = fsz_spm_filemaker(Sz,hdr, savename)

clear ftdata
for s = 1:length(Sz)
    ftdata.trial{s} = Sz(s).eeg; 
    ftdata.time{s}  = Sz(s).etim; 
    cond{s}         = ['Seizure_' num2str(s,'%02.f')]; 
end
ftdata.label        = hdr.label; 

D = spm_eeg_ft2spm(ftdata, savename);
D = type(D, 'single'); 

for c = 1:length(cond)
    D = conditions(D, c, cond{c}); 
end

% Load sensor locations
%--------------------------------------------------------------------------
SP.task     = 'defaulteegsens';
SP.D        = D;
D           = spm_eeg_prep(SP);

% Save MEEG object
%--------------------------------------------------------------------------
save(D);