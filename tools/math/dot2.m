function C = dot2(A, B, C)
% Take the pair-wise dot product of two lists of matrices
% Returns a list of matrices which are the products. 
% The list has length size(A)(3)
% Axis 3 is the list axis (outermost)
%
% Inputs
%       A  : 3D matrix of shape (m,k,l)
%       B  : 3D matrix of shape (k,n,l)
%       C  : optional, could be used for passing in
%            pre-allocated space for storing results
% -------------------------------------------

sA = size(A);
sB = size(B);

% Length along outermost axis
lA = sA(3);
lB = sB(3);
if lA ~= lB
    error('Error. A and B must have the same length along the d-th axis.')
end

% Dimension of final matrix
mA = sA(1);
nB = sB(2);

% If C is not provided, allocate empty space for results
if nargin < 3
    C = zeros(mA, nB, lA);
end

% Calculate dot products
for i = 1 : lA
    C(:,:,i) = A(:,:,i) * B(:,:,i);
end

end
