% fsz - fNIRS seizure analysis

% Housekeeping
%==========================================================================
fs  = filesep; 
F   = fsz_org_housekeeping;

% Load fNIRS data and convert to normalised regressors
%==========================================================================
fnirs = fsz_load_fnirs([F.data fs 'fNIRS.xlsx']); 
fcomp = fsz_pca_comp(fnirs, {'L','R'}, {'hbr', 'cco'}); 

%% Load EEG and convert to time-frequency MEEG files
%==========================================================================
[eeg hdr] = fsz_load_edf([F.data fs 'EEG.EDF']); 
Sz        = fsz_seg_seizures(fnirs, fcomp, eeg, hdr, [5,120]); 
D         = fsz_spm_filemaker(Sz, hdr, [F.analysis fs 'MEEG_Seizure']); 

% Time frequency analysis
%--------------------------------------------------------------------------
clear job
job{1}.spm.meeg.tf.tf.D                 = {[F.analysis fs 'MEEG_Seizure.mat']};
job{1}.spm.meeg.tf.tf.channels{1}.all   = 'all';
job{1}.spm.meeg.tf.tf.frequencies       = [1:100];
job{1}.spm.meeg.tf.tf.timewin           = [-Inf Inf];
job{1}.spm.meeg.tf.tf.method.hilbert.freqres        = 0.5;
job{1}.spm.meeg.tf.tf.method.hilbert.filter.type    = 'but';
job{1}.spm.meeg.tf.tf.method.hilbert.filter.dir     = 'twopass';
job{1}.spm.meeg.tf.tf.method.hilbert.filter.order   = 3;
job{1}.spm.meeg.tf.tf.method.hilbert.polyorder      = 1;
job{1}.spm.meeg.tf.tf.method.hilbert.subsample      = 1;
job{1}.spm.meeg.tf.tf.phase             = 0;
job{1}.spm.meeg.tf.tf.prefix            = '';
spm_jobman('run', job);

% Rescale time frequency estimaates
%--------------------------------------------------------------------------
clear job
job{1}.spm.meeg.tf.rescale.D            = {[F.analysis fs 'tf_MEEG_Seizure.mat']};
job{1}.spm.meeg.tf.rescale.method.LogR.baseline.timewin         = [-Inf 0];
job{1}.spm.meeg.tf.rescale.method.LogR.baseline.pooledbaseline  = 0;
job{1}.spm.meeg.tf.rescale.method.LogR.baseline.Db              = [];
job{1}.spm.meeg.tf.rescale.prefix       = 'r';
spm_jobman('run', job);

%% Convert to image
%--------------------------------------------------------------------------
clear job
[val newt] = min(abs(times - t));
job{1}.spm.meeg.images.convert2images.D = {[F.analysis fs 'rtf_MEEG_Seizure.mat']};
job{1}.spm.meeg.images.convert2images.mode = 'time x frequency';
job{1}.spm.meeg.images.convert2images.conditions = {};
job{1}.spm.meeg.images.convert2images.channels{1}.all = 'all';
job{1}.spm.meeg.images.convert2images.timewin = [-Inf Inf];
job{1}.spm.meeg.images.convert2images.freqwin = [1 48];
job{1}.spm.meeg.images.convert2images.prefix = [];
spm_jobman('run', job);


%%
list = dir([F.analysis]);

%% Smooth images
%--------------------------------------------------------------------------
niftis = dir([F.analysis fs 'rtf_MEEG_Seizure' fs 'cond*']);
niftis = {niftis.name}'; 
for n = 1:length(niftis),   niftis{n} = [F.analysis fs 'rtf_MEEG_Seizure' fs niftis{n}]; end

clear job
job{1}.spm.spatial.smooth.data = niftis;
job{1}.spm.spatial.smooth.fwhm = [2 2 4];
job{1}.spm.spatial.smooth.dtype = 0;
job{1}.spm.spatial.smooth.im = 0;
job{1}.spm.spatial.smooth.prefix = 's';
spm_jobman('run', job);

%% 
niftis = dir([F.analysis fs 'rtf_MEEG_Seizure' fs 'scond*']);
nii = niftiread([niftis(1).folder fs niftis(1).name]); 
imagesc(squeeze(nii(:,:,end)))

%%
clear job
Fspm = [Fanalysis fs 'SPM'];

job{1}.spm.stats.factorial_design.dir = {Fspm};
job{1}.spm.stats.factorial_design.des.mreg.scans    = scans;
job{1}.spm.stats.factorial_design.des.mreg.mcov     = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
job{1}.spm.stats.factorial_design.des.mreg.incint   = 1;

job{1}.spm.stats.factorial_design.cov(1).c      = K;
job{1}.spm.stats.factorial_design.cov(1).cname  = 'K-bit';
job{1}.spm.stats.factorial_design.cov(1).iCFI   = 1;
job{1}.spm.stats.factorial_design.cov(1).iCC    = 1;

job{1}.spm.stats.factorial_design.cov(2).c      = age;
job{1}.spm.stats.factorial_design.cov(2).cname  = 'Age';
job{1}.spm.stats.factorial_design.cov(2).iCFI   = 1;
job{1}.spm.stats.factorial_design.cov(2).iCC    = 1;

bage    = age - min(age);
mage    = 2*bage / max(bage) - 1; 
bkbit   = K - min(K);
mkbit   = 2*bkbit / max(bkbit) - 1;
itx     = mkbit .* mage;

job{1}.spm.stats.factorial_design.cov(3).c      = itx;
job{1}.spm.stats.factorial_design.cov(3).cname  = 'Interaction';
job{1}.spm.stats.factorial_design.cov(3).iCFI   = 1;
job{1}.spm.stats.factorial_design.cov(3).iCC    = 1;

job{1}.spm.stats.factorial_design.cov(4).c      = spl;
job{1}.spm.stats.factorial_design.cov(4).cname  = 'Split';
job{1}.spm.stats.factorial_design.cov(4).iCFI   = 1;
job{1}.spm.stats.factorial_design.cov(4).iCC    = 1;

job{1}.spm.stats.factorial_design.cov(5).c      = sess;
job{1}.spm.stats.factorial_design.cov(5).cname  = 'Sess';
job{1}.spm.stats.factorial_design.cov(5).iCFI   = 1;
job{1}.spm.stats.factorial_design.cov(5).iCC    = 1;

job{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
job{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
job{1}.spm.stats.factorial_design.masking.im = 1;
job{1}.spm.stats.factorial_design.masking.em = {''};
job{1}.spm.stats.factorial_design.globalc.g_omit = 1;
job{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
job{1}.spm.stats.factorial_design.globalm.glonorm = 1;

job{2}.spm.stats.fmri_est.spmmat = {[Fspm fs 'SPM.mat']};
job{2}.spm.stats.fmri_est.write_residuals = 0;
job{2}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run', job);
clear job

% Run SPM to identify scalp correlates of fNIRS regressors 