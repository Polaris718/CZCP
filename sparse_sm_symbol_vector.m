%% 验证与构造步骤
N = 4;
k = 2;
n_k = 3;              % n(k)

%% 验证与构造步骤
e = zeros(N, 1);
e(n_k) = 1;

%% 验证与构造步骤
S = diag(randn(N, 1));

%% 验证与构造步骤
d_k = S * e;

%% 验证与构造步骤
disp('Output');
disp('d_k = ');
disp(d_k);
