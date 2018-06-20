function tr = trace2(A, tr)
% Take the trace of each matrix in a list
% Returns the traces, a column vector of length size(A)(3)
% Axis 3 is the list axis (outermost)
%
% Inputs
%       A  : 3D matrix of shape (m,m,n)
%       tr : optional, could be used for passing in
%            pre-allocated space for storing results
% -------------------------------------------

s = size(A);

% Length along outermost axis
n = s(3);

% If tr is not provided, allocate empty space for results
if nargin < 2
    tr = zeros(n,1);
end

% Calculate traces
for i = 1 : n
    tr(i) = trace(A(:,:,i));
end

end