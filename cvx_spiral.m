function [stats, x] = cvx_spiral(nout, P_ABC, solver, basis, slack, optimizer)


switch solver
    case "MSK_OPTIMIZER_INTPNT"
        cvx_solver('Mosek');
        cvx_solver_settings('MSK_IPAR_OPTIMIZER',convertStringsToChars(solver));
    case "MSK_OPTIMIZER_PRIMAL_SIMPLEX"
        cvx_solver('Mosek');
        cvx_solver_settings('MSK_IPAR_OPTIMIZER',convertStringsToChars(solver));
    case "MSK_OPTIMIZER_DUAL_SIMPLEX"
        cvx_solver('Mosek');
        cvx_solver_settings('MSK_IPAR_OPTIMIZER',convertStringsToChars(solver));
    otherwise
        %--------------Choose solver and optimizer(mosek)---------------
        cvx_solver(convertStringsToChars(solver));
        if (lower(solver)=="mosek") && (nargin > 5)
            cvx_solver_settings('MSK_IPAR_OPTIMIZER',convertStringsToChars(optimizer));
        end
end

    
%--------------Constraint matrices---------------
[A, b, G, h] = get_spiral_constraints(nout, P_ABC, basis);
    
%--------------CVX without slack---------------
if slack ~= 1
    if G == 0
        cvx_begin
            variable x(nout^6);
            dual variable y;
            subject to 
                y: A * x == b;
                x >= 0;
        cvx_end
    else
        cvx_begin
            variable x(nout^6);
            dual variable y;
            subject to 
                y: A * x == b;
                G * x <= h;
        cvx_end
    end
else
    %--------------CVX with slack---------------
    if G == 0
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
    
end

stats = {cvx_cputime, cvx_status,...
         cvx_optval, dot(b,y), cvx_optval-dot(b,y),...
         cvx_optbnd, cvx_slvitr, cvx_slvtol};

end