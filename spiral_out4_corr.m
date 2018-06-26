function stats = spiral_out4_corr(slack)
% Number of outcomes
nout = 4; 
% Given distribution of observed variables
P_ABC = get_dist('EJM');
% Convert to correlator coordinates
G_ABC = switch_basis_mat('full', 'corr', nout, 3)*P_ABC;

%--------------Constraints---------------
% Marginal equivalence & independence conditions
A = [slice_marginal(nout, 6, [1 2 3]);
    slice_marginal(nout, 6, [4 3]);
    slice_marginal(nout, 6, [5 1]);
    slice_marginal(nout, 6, [6 2]);
    slice_marginal(nout, 6, [4]);
    slice_marginal(nout, 6, [5]);
    slice_marginal(nout, 6, [6]);
    slice_marginal(nout, 6, [4 5 6])];
b = [G_ABC;
    slice_marginal(nout, 3, [1 3]) * G_ABC;
    slice_marginal(nout, 3, [2 1]) * G_ABC;
    slice_marginal(nout, 3, [3 2]) * G_ABC;
    slice_marginal(nout, 3, [1]) * G_ABC;
    slice_marginal(nout, 3, [2]) * G_ABC;
    slice_marginal(nout, 3, [3]) * G_ABC;
    kron(kron(slice_marginal(nout, 3, [1]) * G_ABC, slice_marginal(nout, 3, [2]) * G_ABC),slice_marginal(nout, 3, [3]) * G_ABC)];
G = -switch_basis_mat('corr', 'full', nout, 6);
h = 0;

%--------------CVX without slack---------------
if slack == false
    cvx_begin
        variable x(nout^6);
        dual variable y;
        subject to 
            y: A * x == b;
            G * x <= h;
    cvx_end
    
else
    %--------------CVX with slack---------------
    cvx_begin
        variables x(nout^6) t;
        dual variable y;
        maximize(t);
        subject to 
            y: A * x == b;
            G * x + t <= h;
    cvx_end
   
end

stats = {cvx_cputime, cvx_status,...
         cvx_optval, dot(b,y), cvx_optval-dot(b,y),...
         cvx_optbnd, cvx_slvitr, cvx_slvtol};

end




