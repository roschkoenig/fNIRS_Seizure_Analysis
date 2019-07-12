function sz = fsz_project_sztimes(hdr)
    sz(1).dtsrt = datetime([2018 5 16 14 23 48]);
    sz(1).srt   = seconds(sz(1).dtsrt - datetime(hdr.T0)) * hdr.Fs; 
    sz(1).fsrt  = 925.695;
    sz(1).onset = 'P7'; 

    sz(2).dtsrt = datetime([2018 5 16 14 27 10]); 
    sz(2).srt   = seconds(sz(2).dtsrt - datetime(hdr.T0)) * hdr.Fs; 
    sz(2).fsrt  = 1128; 
    sz(2).onset = 'P7'; 