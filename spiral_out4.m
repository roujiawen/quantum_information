function stats = spiral_out4(basis, slack)
switch basis
    case 'full'
        stats = spiral_out4_full(slack);
    case 'CG'
        stats = spiral_out4_CG(slack);
    case 'corr'
        stats = spiral_out4_corr(slack);
end
end