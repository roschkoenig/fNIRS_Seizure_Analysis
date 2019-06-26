function fnirs = fsz_load_fnirs(filepath)

[dat, hdr] = xlsread(filepath); 
hid        = find(~cellfun(@isempty, hdr(1,:))); 

clear fnirs
for h = 2:length(hid)
    spacepos        = find(hdr{1,hid(h)} == ' ');
    chid            = hdr{1,hid(h)}(spacepos(end)+1:end);
    side            = chid(1); 
    num             = chid(2); 
    
    fnirs(h-1).name = hdr{1,hid(h)}; 
    fnirs(h-1).chid = chid; 
    fnirs(h-1).side = side; 
    fnirs(h-1).num  = num;
    fnirs(h-1).hhb  = dat(:,hid(h)); 
    fnirs(h-1).hbo2 = dat(:,hid(h)+1);
    fnirs(h-1).hbr  = fnirs(h-1).hbo2 / fnirs(h-1).hhb;
    fnirs(h-1).cco  = dat(:,hid(h)+2); 
    fnirs(h-1).time = dat(:,1); 
end