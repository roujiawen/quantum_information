% ----------Orthogonal scenario-------------

% parameters
n = 2;% number of indices/states
m = 2;% dimension of state space
p = [0.3 0.7]; % probabilities of Alice sending the i-th state
basis = 'Z';

% create eigenstates
switch basis
    case 'X'
        s1 = 1/sqrt(2) * [1; 1];
        s2 = 1/sqrt(2) * [1; -1];
    case 'Y'
        s1 = 1/sqrt(2) * [1; i];
        s2 = -1/sqrt(2)* [1; -i];
    case 'Z'
        s1 = [1; 0];
        s2 = [0; 1];
end

% create density matrices
rho = zeros(m, m, n); % list of n density matrices of size (m,m)
rho(:,:,1) = s1 * s1';
rho(:,:,2) = s2 * s2';

% run qsd program and print results
E = qsd(n, m, p, rho);
pprint_cmat(E);

% ----------4 states scenario-------------

% parameters
n = 4;% number of indices/states
m = 2;% dimension of state space

% density matrices
r1 = [1 0; 0 0];
r2 = [0 0; 0 1];
r3 = 1/2 * [1 1; 1 1];
r4 = 1/2 * [1 -1; -1 1];
rho = cat(3, r1, r2, r3, r4); % list of n density matrices of size (m,m)

% try different probabilities
p = [0.5 0.1 0.2 0.2]; % probabilities of Alice sending the i-th state
E5122 = qsd(n, m, p, rho);% opt=0.625

p = [0.1 0.7 0.1 0.1];
E1711 = qsd(n, m, p, rho);% opt=0.8

p = [0.2 0.1 0.6 0.1];
E2161 = qsd(n, m, p, rho);% opt=0.716

p = [0.25 0.25 0.25 0.25];
E2222 = qsd(n, m, p, rho);% opt=0.5

pprint_cmat(E5122);
pprint_cmat(E1711);
pprint_cmat(E2161);
pprint_cmat(E2222);

