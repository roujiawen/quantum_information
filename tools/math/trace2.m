function tr = trace2(A, d)
% Take the trace of each matrix in a list
% Returns the traces, a column vector of length size(A)(d)
% d specifies the outer axis (that links matrices together)
% Only d=3 is implemented so far.

if (nargin > 1) && (d ~= 3)
    error('Error. Not implemented.')
end
s = size(A);
% Length along outer axis
n = s(3);
% Allocate empty space for traces
tr = zeros(n,1);
for i = 1 : n
    tr(i) = trace(A(:,:,i));
end

end