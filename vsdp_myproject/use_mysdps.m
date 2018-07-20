rng(333);
m = 2;
n = 5;
A = rand(m, n);
b = rand(m, 1);
c = rand(n, 1);
K.l = n;

A = [-1 2 0 1 1; 0 0 -1 0 2];
b = [2 3]';
c = [0 2 0 3 5]';
K.l = 5;

vsdpinit('sdpt3');
[objt xt yt zt info] = mysdps(A,b,c,K);

% fprintf('\nPrimal obj: %f Dual obj: %f\n', full(dot(c,x)), full(dot(b,y)));

