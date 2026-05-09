%% 1. 定义参数 (与原公式符号一一对应)
mu      = 4;
q       = 4;
x       = [1, 0, 1, 0];   % 输入向量 x
pi_vec  = [1, 2, 3, 4];   % 置换 π
w       = [1, 1, 1, 1];   % 权重 w_k
w_const = 0;               % 常数项 w

%% 2. 核心公式计算
% 第一项：(q/2) * 求和(x_π(k) * x_π(k+1))
sum1 = 0;
for k = 1:mu-1
    sum1 = sum1 + x(pi_vec(k)) * x(pi_vec(k+1));
end
term1 = (q / 2) * sum1;

% 第二项：求和(w_k * x_k)
term2 = sum(w .* x);

% 3. 最终结果
g_x = term1 + term2 + w_const;

%% 4. 输出验证
disp('=== 公式验证计算 ===');
disp(['项1 (二次交叉): ', num2str(term1)]);
disp(['项2 (线性加权): ', num2str(term2)]);
disp(['常数项: ', num2str(w_const)]);
disp(['------------------']);
disp(['最终 g(x) = ', num2str(g_x)]);