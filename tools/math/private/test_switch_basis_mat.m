% Add parent folder to path
addpath(fileparts(pwd))

success = 1;
for n=1:10
    if sum(sum(p2cg(n)~=switch_basis_mat('full','CG',2,n))) ~= 0
        success = 0;
    end
    if sum(sum(p2co(n)~=switch_basis_mat('full','corr',2,n))) ~= 0
        success = 0;
    end
    if sum(sum(cg2p(n)~=switch_basis_mat('CG','full',2,n))) ~= 0
        success = 0;
    end
    if sum(sum(co2p(n)~=switch_basis_mat('corr','full',2,n))) ~= 0
        success = 0;
    end
    if sum(sum(eye(n) - switch_basis_mat('corr','full',n,1) * switch_basis_mat('full','corr',n,1))) > 0.000001
        success = 0;
    end
    if sum(sum(eye(n) - switch_basis_mat('CG','full',n,1) * switch_basis_mat('full','CG',n,1))) > 0.000001
        success = 0;
    end
end

if success
    fprintf('Passed the test!\n');
else
    fprintf('Failed the test!\n');
end