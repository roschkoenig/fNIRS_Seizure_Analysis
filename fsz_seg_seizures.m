function Sz = fsz_seg_seizures(fnirs, fcomp, eeg, hdr, times); 

figure
% Pull out relevant data segments
%--------------------------------------------------------------------------
sz = fsz_project_sztimes(hdr); 
presecs     = times(1); 
postsecs    = times(2); 

for s = 1:length(sz)
    onid = find(strcmp(hdr.label, sz(s).onset)); 
    win  = sz(s).srt - presecs*hdr.Fs : sz(s).srt + postsecs*hdr.Fs; 
    tim  = [win - sz(s).srt] / hdr.Fs;
    
    subplot(4,1,2*s-1)
        plot(tim, eeg(onid,win)); 
        xlim([-Inf Inf]); 
        
    ftime       = fnirs(1).time; 
    [val id]    = min(abs(ftime - (sz(s).fsrt-presecs)));
    
    subplot(4,1,2*s)
        plot(squeeze(fcomp(:,2,id:(id+presecs+postsecs)))');
        xlim([-Inf Inf]); 
        
    Sz(s).eeg   = eeg(:,win); 
    Sz(s).etim  = tim;
    Sz(s).nirs  = fcomp(:,:,id:(id+presecs+postsecs));
    Sz(s).ftim  = linspace(tim(1),tim(end), length(Sz(s).nirs)); 
end
