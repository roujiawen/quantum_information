
%-------------- toy problem ---------------------
% c     = [3 1 5 1]';
% a     = sparse([[3 1 2 0];[2 1 3 1];[0 2 0 3]]);
% blc   = [30 15  -inf]';
% buc   = [30 inf 25 ]';
% blx   = zeros(4,1);
% bux   = [inf 10 inf inf]';

%-------------- random problem ---------------------
% rng('default');
% rng(333);
% m = 20;
% n = 50;
% A = rand(m, n);
% b = rand(m, 1);
% c = rand(n, 1);
% K.l = n;
% A = A';

%-------------- spiral inflation ---------------------
const_type = 'ineq';
for name = {'W-type', 'complete correlation', 'anti-correlation', 'uniform', 'EJM', 'fail1'}
    fprintf('---------------%s---------------\n', name{1});
    [A, b] = get_spiral_form(const_type, 'corr', get_dist(name{1}));
    mosek_wrapper(A,b,const_type);
end





