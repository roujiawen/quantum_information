function spiral_out4(basis, slack)
    if strcmp(basis, 'full')
        spiral_out4_full(slack);
    elseif strcmp(basis, 'CG')
        spiral_out4_CG(slack);
    elseif strcmp(basis, 'corr')
        spiral_out4_corr(slack);
    end
end