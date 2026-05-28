%% 验证或构造步骤
mu      = 4;
q       = 4;
x       = [1, 0, 1, 0];  % 实现说明。
pi_vec  = [1, 2, 3, 4];  % 实现说明。
w       = [1, 1, 1, 1];  % 实现说明。
w_const = 0;  % 实现说明。

%% 验证或构造步骤
% 实现说明。
sum1 = 0;
for k = 1:mu-1
    sum1 = sum1 + x(pi_vec(k)) * x(pi_vec(k+1));
end
term1 = (q / 2) * sum1;

% 实现说明。
term2 = sum(w .* x);

% 实现说明。
g_x = term1 + term2 + w_const;

%% 验证或构造步骤
disp('Output');
disp(['Output', num2str(term1)]);
disp(['Output', num2str(term2)]);
disp(['Output', num2str(w_const)]);
disp(['------------------']);
disp(['Output', num2str(g_x)]);
