% Triangle
% Without using Kronecker Delta
% Optimization variable in the shape of (2,2,2)
% Handwritten rules
% Conditions still in original P coordinates

zero_vector = zeros(2,2,2);
cvx_begin
    variable x(2,2,2);
    maximize(sum(sum(sum(zero_vector .* x))));
    subject to
        x(1,1,1) == 1;
        x(2,1,1) == 0.5;
        x(1,2,1) == 0.5;
        x(1,1,2) == 0.5;
        
        x(2,2,1) == 0.25;
        x(1,2,2) == 0.5;
        x(2,1,2) == 0.5;
        
        %nonnegative conditions
        x(2,2,2) >= 0;
        x(2,2,1) - x(2,2,2) >= 0;
        x(2,1,2) - x(2,2,2) >= 0;
        x(1,2,2) - x(2,2,2) >= 0;
        x(2,1,1) - x(2,2,1) - x(2,1,2) + x(2,2,2) >= 0;
        x(1,2,1) - x(2,2,1) - x(1,2,2) + x(2,2,2) >= 0;
        x(1,1,2) - x(1,2,2) - x(2,1,2) + x(2,2,2) >= 0;
        x(1,1,1) - x(2,1,1) - x(1,2,1) - x(1,1,2) + x(2,2,1) + x(1,2,2) + x(2,1,2) - x(2,2,2) >= 0;        
cvx_end

% RESULTS
% Status: Infeasible
% Optimal value (cvx_optval): -Inf





