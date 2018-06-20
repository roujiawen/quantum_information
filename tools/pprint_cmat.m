function pprint_cmat(mat, sigdig)
% Pretty print complex matrices

if nargin < 1
    mat = complex(rand(3,3,3), rand(3,3,3));
end
% Default display 4 significant digits
if nargin < 2
    sigdig = 4;
end

s = size(mat);
if length(s) == 3
    % 3D matrix (print multiple 2D matrices)
    for k = 1:s(3)
        fprintf('\n');
        print2d(mat(:,:,k),sigdig);
        fprintf('\n');
    end
else
    % 2D matrix
    fprintf('\n');
    print2d(mat, sigdig);
    fprintf('\n');
end
end

function print2d(mat, sigdig)
% print a 2D matrix
    s = size(mat);
    formatspec = sprintf('+%%.%dgi', sigdig);
    realspec = sprintf('%%15.%dg', sigdig);
    imagspec = sprintf('%%14.%dgi', sigdig, sigdig);
    for i = 1:s(1)
        for j = 1:s(2)
            re = round(real(mat(i,j)), sigdig);
            im = round(imag(mat(i,j)), sigdig);
            if im == 0
                fprintf(realspec, re);
            elseif re == 0
                if im == 1
                    fprintf('              i');
                else
                    fprintf(imagspec, im);
                end
            else
                if im == 1
                    fprintf(sprintf('%%13.%dg', sigdig), re);
                    fprintf('+i');
                else
                    formatted = sprintf(formatspec, im);
                    new_spec = sprintf('%%%d.%dg', 15-length(formatted), sigdig);
                    fprintf(new_spec, re);
                    fprintf(formatted);
                end
            end
        end
        fprintf('\n');
    end
end