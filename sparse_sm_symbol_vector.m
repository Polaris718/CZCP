%% Verification and construction steps
N = 4;
k = 2;
n_k = 3;              % n(k)

%% Verification and construction steps
e = zeros(N, 1);
e(n_k) = 1;

%% Verification and construction steps
S = diag(randn(N, 1));

%% Verification and construction steps
d_k = S * e;

%% Verification and construction steps
disp('Output');
disp('d_k = ');
disp(d_k);
