% changable
pattern = [2 3;
     2 3;
     1 1];
solver = 'mosek';
optimizer = 'MSK_OPTIMIZER_FREE_SIMPLEX';
basis = 'full';
slack = 1;

% fixed parameters
nvar = 3;
l_out = 2;
h_out = 4;
infea = false;

            
conv_mat = zeros(h_out, l_out, nvar);
 
 for i3 = 1:3%nvar
     for i2 = 1:2%l_out
         conv_mat(pattern(i3, i2),i2,i3) = 1;
     end
 end
 

 h_dist = low2high_dist(get_dist("uniform"), l_out, h_out, infea, conv_mat);
 cvx_solver_settings('MSK_IPAR_OPTIMIZER',optimizer);
 cvx_solver(solver);
 %cvx_spiral(h_out, h_dist, basis, slack);
 
 