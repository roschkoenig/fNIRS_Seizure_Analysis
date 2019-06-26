function F = fsz_org_housekeeping

fs          = filesep;
spm('defaults', 'eeg');

try     load('fsz_org_housekeeping.mat');   
    
catch
    scripts    = spm_select(1, 'dir', 'Please point to the SCRIPTS folder');
    data       = spm_select(1, 'dir', 'Please point to the DATA folder');
    analysis   = spm_select(1, 'dir', 'Please point to the ANALYSIS folder');
    

    % Pack for exporting
    %==========================================================================
    F.scripts  = scripts;
    F.data     = data;
    F.analysis = analysis;
   
    save([F.scripts fs 'fsz_org_housekeeping.mat'], 'F');
end

addpath(genpath(F.scripts));
addpath(F.data); 
addpath(F.analysis);
