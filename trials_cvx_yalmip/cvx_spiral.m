function [stats, x] = cvx_spiral(nout, P_ABC, solver, basis, slack, optimizer)

cvx_solver_settings('-clearall')
switch solver
    case 'Mosek_INTPNT'
        cvx_solver('Mosek');
        cvx_solver_settings('MSK_IPAR_OPTIMIZER','MSK_OPTIMIZER_INTPNT');
    case 'Mosek_INTPNT_ONLY'
        cvx_solver('Mosek');
        cvx_solver_settings('MSK_IPAR_OPTIMIZER', 'MSK_OPTIMIZER_INTPNT');
        cvx_solver_settings('MSK_IPAR_INTPNT_BASIS', 0);
    case 'Mosek_PRIMAL_SIMPLEX'
        cvx_solver('Mosek');
        cvx_solver_settings('MSK_IPAR_OPTIMIZER','MSK_OPTIMIZER_PRIMAL_SIMPLEX');
    case 'Mosek_DUAL_SIMPLEX'
        cvx_solver('Mosek');
        cvx_solver_settings('MSK_IPAR_OPTIMIZER','MSK_OPTIMIZER_DUAL_SIMPLEX');
    otherwise
        %--------------Choose solver and optimizer(mosek)---------------
        cvx_solver(solver);
        if (strcmpi(solver, 'mosek')) && (nargin > 5)
            cvx_solver_settings('MSK_IPAR_OPTIMIZER',optimizer);
        end
end

    
%--------------Constraint matrices---------------
[A, b, G, h] = get_spiral_constraints(nout, P_ABC, basis);
    
%--------------CVX without slack---------------
switch slack
    case {0, 'noslack'}
        if length(G) == 1%full, CG, corr
            cvx_begin
                variable x(nout^6);
                dual variable y;
                subject to 
                    y: A * x == b;
                    x >= 0;
            cvx_end
        else%CG_old, corr_old
            cvx_begin
                variable x(nout^6);
                dual variable y;
                subject to 
                    y: A * x == b;
                    G * x <= h;
            cvx_end
        end
        primalopt = cvx_optval;
        dualopt = dot(b,y);
    case {1, 'slack(x>=t)'}
        %--------------CVX with slack(x>=t)---------------
        if length(G) == 1
            cvx_begin
                variables x(nout^6) t;
                dual variable y;
                maximize t;
                subject to 
                    y: A * x == b;
                    x >= t;
            cvx_end
        else
            cvx_begin
                variables x(nout^6) t;
                dual variable y;
                maximize(t);
                subject to 
                    y: A * x == b;
                    G * x + t <= h;
            cvx_end
        end
        primalopt = cvx_optval;
        dualopt = -dot(b,y);
    case {2, 'slack_v2(|t|<=1)'}
        %--------------CVX with slack(-1<t<1)---------------
        if length(G) == 1
            cvx_begin
                variables x(nout^6) t;
                dual variable y;
                maximize t;
                subject to 
                    y: A * x == b;
                    x >= t;
                    -1 <= t <= 1;
            cvx_end
        else
            error('Not implemented');
        end
        
        primalopt = cvx_optval;
        dualopt = -dot(b,y);
    case {3, 'slack(x=y-t+1)'}
        %--------------CVX with slack(x=y-t+1)---------------
        if length(G) == 1
            A_sum = sum(A,2);
            cvx_begin
                variables x(nout^6) t;
                dual variable y;
                minimize t;
                subject to
                    y: A*x - A_sum * t == b - A_sum;
                    x >= 0;
                    t >= 0;
            cvx_end
        else
            error('Not implemented');
        end
        primalopt = cvx_optval;
        dualopt = dot(b - A_sum,y);
end
gap = primalopt-dualopt;
stats = {cvx_cputime, cvx_status,...
         primalopt, dualopt, gap,...
         cvx_optbnd, cvx_slvitr, cvx_slvtol};

end