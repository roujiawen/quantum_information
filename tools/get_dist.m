function P = get_dist(name)
% Returns one of the following distributions:
% - 'W-type'
% - 'complete correlation'
% - 'EJM'

    switch name
        case 'W-type'
            P = [0;1/3;1/3;0;1/3;0;0;0];
        case 'complete correlation'
            P = [0.5;0;0;0;0;0;0;0.5];
        case 'EJM'
            P = gen_ejm();
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