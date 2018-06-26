function stats = spiral_out4(basis, slack)
    if strcmp(basis, 'full')
        stats = spiral_out4_full(slack);
    elseif strcmp(basis, 'CG')
        stats = spiral_out4_CG(slack);
    elseif strcmp(basis, 'corr')
        stats = spiral_out4_corr(slack);
    end
end