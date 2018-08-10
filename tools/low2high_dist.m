function h_dist = low2high_dist(varargin)
% LOW2HIGH_DIST generate random distribution with higher number of 
% outcomes which has the same feasibility with a corresponding 
% distribution with lower number of outcomes.
% Assumes 3 observed variables (triangle scenario)

% low2high_dist(dist_name, h_out, use_interval, seed)
% OR
% low2high_dist(l_out, l_dist, h_out, use_interval, seed)


%% Handling input arguments
if ischar(varargin{1})%if distribution name is provided
    [dist_name, h_out] = varargin{:};
    core_nargin = 2;
else%if distribution P_ABC is explicitly given
    [l_out, l_dist, h_out] = varargin{:};
    core_nargin = 3;
end

if nargin - core_nargin < 1
    use_interval = false; %default
else
    use_interval = varargin{core_nargin+1};
    if isempty(use_interval)
        use_interval = false;
    end
end

if (nargin - core_nargin >= 2) 
    seed = varargin{core_nargin+2};
    if ~isempty(seed)
        rng(seed, 'v5uniform');%fixed seed
    end
end

if core_nargin == 2
    % Get original (lower-outcome) distribution
    [l_dist, l_out] = get_dist(dist_name, use_interval);
end

%% Main algorithm
nvar = 3;

% Generate random invertibly normalizable matrix
%     (1) generate matrix
%         .5 0  0
%         .5 0  0
%         0  .3 0
%         0  .4 0
%         0  .3 0
%         0  0  1
%     (2) shuffle rows
if use_interval
    conv_mat = intval(zeros(h_out, l_out, nvar));
    % Do this for every layer(nvar):
    for layer = 1:nvar
        % Gen random lengths of vectors that sum to a total of h_out
        col_nonzeros = ones(1, l_out);%at least 1 nonzero entries
        for k = 1:h_out-l_out%each time add 1 at a random index
            rand_index = randi(l_out);
            col_nonzeros(1, rand_index) = col_nonzeros(1, rand_index) + 1;
        end
        % Create random normalized vectors and place inside matrix
        slices = [0 cumsum(col_nonzeros)];
        for k = 1:l_out
            % Random normalized vector of shape (#nonzero, 1)
            rand_mat = intval(rand(col_nonzeros(1,k),1));
            divisor = sum(rand_mat);
            rand_mat = rand_mat/divisor;
            % Place random vector inside the matrix
            conv_mat(slices(k)+1:slices(k+1), k, layer) = rand_mat;
        end
        % Shuffle rows of the matrix
        conv_mat(:,:,layer) = conv_mat(randperm(size(conv_mat,1)),:,layer);
    end
else
    conv_mat = zeros(h_out, l_out, nvar);
    % Do this for every layer(nvar):
    for layer = 1:nvar
        % Determine lengths of vectors
        col_nonzeros = ones(1, l_out);%at least 1 nonzero entries
        for k = 1:h_out-l_out
            rand_index = randi(l_out);
            col_nonzeros(1, rand_index) = col_nonzeros(1, rand_index) + 1;
        end
        % Create random vectors and place inside matrix
        slices = [0 cumsum(col_nonzeros)];
        for k = 1:l_out
            % Random normalized vector of shape (#nonzero, 1)
            rand_mat = rand(col_nonzeros(1,k),1);
            divisor = sum(rand_mat);
            rand_mat = rand_mat/divisor;
            % Place random vector inside the matrix
            conv_mat(slices(k)+1:slices(k+1), k, layer) = rand_mat;
        end
        % Shuffle rows of the matrix
        conv_mat(:,:,layer) = conv_mat(randperm(size(conv_mat,1)),:,layer);
    end
end


% Take kronecker product e.g. C x B x A
kron_prod = 1;
for k = 1:nvar
    kron_prod = kron(kron_prod, conv_mat(:,:,k));
end

% Multiply by original distribution
h_dist = kron_prod * l_dist;

%---------Code for verbose printouts---------
% rank(kron_prod)
% spy(kron_prod);
% find(h_dist)
% sum(sort(65 - find(h_dist)) ~= find(h_dist)) == 0
% h_dist(find(h_dist))

end