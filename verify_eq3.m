% 验证公式(3)：φ(a,b)(τ) = ρ(a,b)(τ) + conj(ρ(b,a)(N-τ))
clear; clc;

% 1. 定义测试向量（实数向量，共轭不影响结果）
N = 5;
a = [1; 2; 3; 4; 5];  % 数学下标：a0=1, a1=2, a2=3, a3=4, a4=5
b = [2; 4; 6; 8; 10]; % 数学下标：b0=2, b1=4, b2=6, b3=8, b4=10
tau = 2;               % 测试延迟τ=2

% 2. 计算等式各部分值
% 左边：循环互相关φ(a,b)(τ)
phi = cyclic_cross_correlation(a, b, tau);

% 右边第一部分：线性互相关ρ(a,b)(τ)
rho_ab = linear_cross_correlation(a, b, tau);

% 右边第二部分：ρ(b,a)(N-τ)的复共轭
tau_prime = N - tau;  % N-τ=3
rho_ba = linear_cross_correlation(b, a, tau_prime);
rho_ba_conj = conj(rho_ba);

% 右边总和
right_side = rho_ab + rho_ba_conj;

% 3. 输出对比结果
disp(['=== 公式(3)验证结果 ===']);
disp(['循环互相关 φ(a,b)(', num2str(tau), ') = ', num2str(phi)]);
disp(['线性互相关 ρ(a,b)(', num2str(tau), ') = ', num2str(rho_ab)]);
disp(['线性互相关 ρ(b,a)(', num2str(tau_prime), ') = ', num2str(rho_ba)]);
disp(['右边总和 ρ(a,b)(τ) + ρ*(b,a)(N-τ) = ', num2str(right_side)]);
disp(['等式是否成立：', num2str(abs(phi - right_side) < 1e-10)]); % 浮点精度容错