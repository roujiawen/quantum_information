function C = dot2(A, B, d)
% Take the pair-wise dot product of two lists of matrices
% Returns a list of matrices which are the products. 
% The list has length size(A)(d)
% d specifies the outer axis (that links matrices together)
% Only d=3 is implemented so far.

if (nargin > 2) && (d ~= 3)
    error('Error. Not implemented.')
end
sA = size(A);
sB = size(B);
% Length along outer axis
lA = sA(3);
lB = sB(3);
if lA ~= lB
    error('Error. A and B must have the same length along the d-th axis.')
end
% Dimension of final matrix
mA = sA(1);
nB = sB(2);
% Allocate empty space for C
C = zeros(mA, nB, lA);
for i = 1 : lA
    C(:,:,i) = A(:,:,i) * B(:,:,i);
end

end
