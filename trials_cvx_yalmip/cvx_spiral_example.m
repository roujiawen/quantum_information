basis = 'full';
slack = 0;
% Given
nout = 4; % Number of outcomes
P_ABC = get_dist('EJM');

%--------------Constraint matrices---------------
[A, b, G, h] = get_spiral_constraints(nout, P_ABC, basis);

%--------------CVX without slack---------------
if slack == false
    cvx_begin
        variable x(nout^6);
        dual variable y;
        subject to 
            y: A * x == b;
            x >= 0;
    cvx_end
else
    %--------------CVX with slack---------------
    cvx_begin
        variables x(nout^6) t;
        dual variable y;
        maximize t;
        subject to 
            y: A * x == b;
            x >= t;
    cvx_end
end