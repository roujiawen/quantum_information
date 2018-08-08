function [P, nout, feasibility] = get_dist(name, use_interval, trial_id)
% Returns one of the following distributions:
% FEASIBLE:
% - 'uniform'
% - 'anti-correlation'
% - 'EJM'
% - 'fail1'
% - 'fail2'
% - 'fail3'
% INFEASIBLE:
% - 'W-type'
% - 'complete correlation'

if (nargin < 2) || isempty(use_interval)
    use_interval = false; %default
end

if strcmp(name, '500trials')
    %from feasible distributions only
    load('logs/4-500trials/test_data_rand_fea_500trials.mat', 'test_data');
    P = test_data(:, trial_id);
    nout = 4;
    feasibility = true;
    return;
end

if use_interval
    switch name
        case 'uniform'
            P = intval(ones(8,1))/8;
            nout = 2;
            feasibility = true;
        case 'complete correlation'
            P = intval([1;0;0;0;0;0;0;1])/2;
            nout = 2;
            feasibility = false;
        case 'W-type'
            P = intval([0;1;1;0;1;0;0;0])/3;
            nout = 2;
            feasibility = false;
        case 'EJM'
            P = gen_ejm_use_interval();
            nout = 4;
            feasibility = true;
        otherwise
            error('Not implemented');
    end
else
    switch name
        case 'uniform'
            P = 1/8 * ones(8,1);
            nout = 2;
            feasibility = true;
        case 'anti-correlation'
            P = 1/6 * [0;1;1;1;1;1;1;0];
            nout = 2;
            feasibility = true;
        case 'fail1'
            load('logs/test_data_100trials/test_data_4.mat', 'test_data');
            trial = 10;
            P = test_data(:,trial);
            nout = 4;
            feasibility = true;
        case 'fail2'
            load('logs/test_data_100trials/test_data_4.mat', 'test_data');
            trial = 73;
            P = test_data(:,trial);
            nout = 4;
            feasibility = true;
        case 'fail3'
            load('logs/test_data_100trials/test_data_4.mat', 'test_data');
            trial = 88;
            P = test_data(:,trial);
            nout = 4;
            feasibility = true;
        case 'W-type'
            P = [0;1/3;1/3;0;1/3;0;0;0];
            nout = 2;
            feasibility = false;
        case 'complete correlation'
            P = [0.5;0;0;0;0;0;0;0.5];
            nout = 2;
            feasibility = false;
        case 'EJM'
            P = gen_ejm();
            nout = 4;
            feasibility = true;
        otherwise
            error('Not implemented');
    end
end
end

            
function P = gen_ejm()
    M = ones(4,4,4)*5/256;
    for i = 1:4
        for j = 1:4
            M(i,i,j) = 1/256;
            M(i,j,i) = 1/256;
            M(j,i,i) = 1/256;
        end
        M(i,i,i) = 25/256;
    end
    P = M(:);
end

function P = gen_ejm_use_interval()
    M = intval(ones(4,4,4))*5/256;
    for i = 1:4
        for j = 1:4
            M(i,i,j) = intval(1)/256;
            M(i,j,i) = intval(1)/256;
            M(j,i,i) = intval(1)/256;
        end
        M(i,i,i) = intval(25)/256;
    end
    P = M(:);
end
