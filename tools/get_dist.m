function P = get_dist(name)
% Returns one of the following distributions:
% - 'W-type'
% - 'complete correlation'
% - 'uniform'
% - 'anti-correlation'
% - 'EJM'

    switch name
        case "uniform"
            P = 1/8 * ones(8,1);
        case "anti-correlation"
            P = 1/6 * [0;1;1;1;1;1;1;0];
        case "W-type"
            P = [0;1/3;1/3;0;1/3;0;0;0];
        case "complete correlation"
            P = [0.5;0;0;0;0;0;0;0.5];
        case "EJM"
            P = gen_ejm();
        case "half-A"
            % 3 9 33
            P = gen_half(4, 2);
        case "half-B"
            P = gen_half(4, 5);
        case "half-C"
            P = gen_half(4, 17);
        case "out2half-A"
            % 3 9 33
            P = gen_half(2, 2);
        case "out2half-B"
            P = gen_half(2, 3);
        case "out2half-C"
            P = gen_half(2, 5);
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

function P = gen_half(nout, k)
    P = zeros(nout^3,1);
    P(1) = 0.5;
    P(k) = 0.5;
end