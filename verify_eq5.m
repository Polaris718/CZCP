%% 公式(5)验证
clear; clc;

% 标准长度4的Golay互补对。
a = [1;  1;  1; -1];
b = [1;  1; -1;  1];
N = length(a);

% 配对规则：c为b翻转后的共轭，d为a翻转共轭后的相反数。
c = flip(conj(b));
d = -flip(conj(a));

test_taus = -3:3;
disp('=== Formula (5) verification result for the paired sequences ===');
for tau = test_taus
    rho_ac = full_linear_cross_correlation(a, c, tau);
    rho_bd = full_linear_cross_correlation(b, d, tau);
    sum_rho = rho_ac + rho_bd;
    is_zero = abs(sum_rho) < 1e-10;

    fprintf('tau=%2d -> rho(a,c)=%.0f, rho(b,d)=%.0f, sum=%.0f, satisfied=%d\n', ...
        tau, rho_ac, rho_bd, sum_rho, is_zero);
end
