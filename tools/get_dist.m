function [P, nout, feasibility] = get_dist(name)
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
            load('outs/test_data_100trials/test_data_4.mat', 'test_data');
            trial = 10;
            P = test_data(:,trial);
            nout = 4;
            feasibility = true;
        case 'fail2'
            load('outs/test_data_100trials/test_data_4.mat', 'test_data');
            trial = 73;
            P = test_data(:,trial);
            nout = 4;
            feasibility = true;
        case 'fail3'
            load('outs/test_data_100trials/test_data_4.mat', 'test_data');
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

