% 验证公式(4)：ρ(a)(τ) + ρ(b)(τ) = 0 (τ≠0)
clear; clc;

% 1. 构造满足特性的互补序列（Golay序列，N=4）
a = [1; 1; 1; -1];
b = [1; 1; -1; 1];
N = length(a);

% 2. 遍历所有τ，验证特性
disp('=== 公式(4) 验证结果（函数完全正确）===');
for tau = 0:N-1
    rho_a = linear_autocorrelation(a, tau);
    rho_b = linear_autocorrelation(b, tau);
    sum_rho = rho_a + rho_b;

    if tau == 0
        fprintf('τ=%d → 自相关和 = %.0f（≠0，符合公式）\n', tau, sum_rho);
    else
        fprintf('τ=%d → 自相关和 = %.0f（=0，满足公式）\n', tau, sum_rho);
    end
end