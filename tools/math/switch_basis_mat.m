function S = switch_basis_mat(from, to, nout, nvar)
%SWITCH_BASIS A function that returns a switch of basis corresponding
% to the specifications given in the inputs.
% 
% Inputs:
% from   A string, the name of the basis to switch from, can be
%        'full', 'corr', or 'CG'.
% to     A string, the name of the basis to switch to, can be
%        'full', 'corr', or 'CG'.
% nout   An integer, the number of outcomes for each random variable.
%        (e.g. nout for binary variables is 2)
% nvar   An integer specifying the number of variables in the joint
%        probability distribution. (e.g. nvar for P_ABC is 3)
%        
% Outputs:
% S      A matrix, the switch of basis matrix, of the size
%        (nout^nvar, nout^nvar).
% 
% Example:
% >> switch_basis_mat('full', 'CG', 2, 3)
% 
% ans =
% 
%      1     1     1     1     1     1     1     1
%      1     0     1     0     1     0     1     0
%      1     1     0     0     1     1     0     0
%      1     0     0     0     1     0     0     0
%      1     1     1     1     0     0     0     0
%      1     0     1     0     0     0     0     0
%      1     1     0     0     0     0     0     0
%      1     0     0     0     0     0     0     0
%
% -------------------------------------------------------


S_type = strcat(from, to);
switch S_type
    case 'fullCG'
        S1 = fullCG(nout);
    case 'fullcorr'
        S1 = fullcorr(nout);
    case 'CGfull'
        S1 = CGfull(nout);
    case 'corrfull'
        S1 = corrfull(nout);
    otherwise
        error('Error. The given FROM and TO pair has not been implemented.')
end

S = kpow(S1, nvar);
end

function S1 = fullCG(nout)
    S1 = [ones(1, nout);
        eye(nout-1) zeros(nout-1, 1)];
end

function S1 = fullcorr(nout)
    S1 = [ones(1, nout);
        eye(nout-1)*nout-1 -ones(nout-1,1)];
end

function S1 = CGfull(nout)
    S1 = [zeros(nout-1,1) eye(nout-1);
          1 -ones(1, nout-1)];
end

function S1 = corrfull(nout)
    S1 = [ones(nout,1)/nout [eye(nout-1)/nout;
                             -ones(1,nout-1)/nout]];
end

