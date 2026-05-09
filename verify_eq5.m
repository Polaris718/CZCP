%% 公式(5) 验证
clear; clc;

% 1. 用之前验证过的 N=4 标准 Golay 互补序列 a,b
a = [1;  1;  1; -1];  
b = [1;  1; -1;  1];  
N = length(a);

% 2. 按配对规则构造 c,d：c=翻转共轭b，d=-翻转共轭a
c = flip(conj(b));  
d = -flip(conj(a));


% 3. 验证公式(5)
test_taus = -3:3; 
disp('=== 公式(5) 正确验证结果（序列满足配对条件）===');
for tau = test_taus
    rho_ac = full_linear_cross_correlation(a, c, tau);
    rho_bd = full_linear_cross_correlation(b, d, tau);
    sum_rho = rho_ac + rho_bd;
    is_zero = abs(sum_rho) < 1e-10;
    
    fprintf('τ=%2d → ρ(a,c)=%.0f, ρ(b,d)=%.0f, 和=%.0f, 满足=%d\n', ...
        tau, rho_ac, rho_bd, sum_rho, is_zero);
end