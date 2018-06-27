function stats = cvx_spiral(nout, P_ABC, basis, slack)

%--------------Constraint matrices---------------
[A, b, G, h] = get_spiral_constraints(nout, P_ABC, basis);
    
%--------------CVX without slack---------------
if slack == false
    if basis == "full"
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
    if basis == "full"
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