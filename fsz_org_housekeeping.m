function D = fsz_org_housekeeping

fs          = filesep;
spm('defaults', 'eeg');

try     load('fsz_org_housekeeping.mat');   
    
catch
    Fscripts    = spm_select(1, 'dir', 'Please point to the SCRIPTS folder');
    Fdata       = spm_select(1, 'dir', 'Please point to the DATA folder');
    Fanalysis   = spm_select(1, 'dir', 'Please point to the ANALYSIS folder');
    

    % Pack for exporting
    %==========================================================================
    D.Fscripts  = Fscripts;
    D.Fdata     = Fdata;
    D.Fanalysis = Fanalysis;
   
    save([Fscripts fs 'tc_housekeeping.mat']);
end

addpath(genpath(Fscripts));
addpath(Fdata); 
addpath(Fanalysis);
