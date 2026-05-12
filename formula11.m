%% Verification or construction step
N = 4;  % Implementation note.
k = 2;  % Implementation note.
n_k = 3;              % n(k)

%% Verification or construction step
e = zeros(N, 1);
e(n_k) = 1;

%% Verification or construction step
S = diag(randn(N, 1));  % Implementation note.

%% Verification or construction step
d_k = S * e;

%% Verification or construction step
disp('Output');
disp('d_k = ');
disp(d_k);
