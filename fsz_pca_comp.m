function fcomp = fsz_pca_comp(fnirs, sides, type)

% Get principal components over sides
%--------------------------------------------------------------------------
sides   = {'L', 'R'}; 
type    = {'hbr', 'cco'}; 
clear redf
for s = 1:length(sides)
    side = sides{s};
    sideid = find([fnirs.side] == side);
    for t = 1:length(type)
        thisdat = [fnirs(sideid).(type{t})]; 
        [coeff, score] = pca(thisdat); 
        redf(s,t,:)    = zscore(score(:,1)); 
    end
    
    subplot(2,1,s)
    plot(squeeze(redf(s,:,:))'); 
    title(['Side ' side])
    legend(type); 
end

fcomp = redf; 