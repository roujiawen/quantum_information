rng(333);
m = 2;
n = 5;
A = rand(m, n);
b = rand(m, 1);
c = rand(n, 1);
[x, y, info] = sedumi(A,b,c);
fprintf('\nPrimal obj: %f Dual obj: %f\n', full(dot(c,x)), full(dot(b,y)));

