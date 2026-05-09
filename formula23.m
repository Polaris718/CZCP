clear; clc; close all;

%CZCP条件验证
function [is_valid, results] = verify_czcp(a, b, Z)
    N = length(a);
    [tau_all, rho_a] = aperiodic_autocorr(a);
    [~, rho_b] = aperiodic_autocorr(b);
    [~, rho_ab] = aperiodic_crosscorr(a, b);
    [~, rho_ba] = aperiodic_crosscorr(b, a);
    
    % 定义时延集合 T1, T2（对应Definition 4）
    T1 = 1:Z;
    T2 = (N-Z):(N-1);
    idx_C1 = ismember(abs(tau_all), [T1, T2]); % C1的时延范围
    idx_C2 = ismember(abs(tau_all), T2);        % C2的时延范围
    
    % 验证C1和C2
    C1_vals = rho_a(idx_C1) + rho_b(idx_C1);
    C2_vals = rho_ab(idx_C2) + rho_ba(idx_C2);
    
    is_valid_C1 = all(abs(C1_vals) < 1e-10);
    is_valid_C2 = all(abs(C2_vals) < 1e-10);
    
    is_valid = is_valid_C1 && is_valid_C2;
    results.C1_vals = C1_vals;
    results.C2_vals = C2_vals;
    results.tau_C1 = tau_all(idx_C1);
    results.tau_C2 = tau_all(idx_C2);
end

% 只有基序列是GCP，才能保证公式(22)生成的是完美CZCP
q = 4;                  % 4元序列（q为偶数，符合要求）
mu = 2;                 % GBF变量数，生成GCP长度 M=2^mu=4
M = 2^mu;               % 基序列长度

% 定义广义布尔函数
kappa = 0:M-1;
x1 = floor(kappa / 2);  % x1 (最高位)
x2 = mod(kappa, 2);     % x2 (最低位)
g = (q/2)*x1.*x2;       % GBF: g(x) = (q/2)x1x2
g_prime = g + (q/2)*x1; % GBF: g' = g + (q/2)x1

% 生成基GCP序列 (e,f)
omega_q = exp(1i*2*pi/q);
e = omega_q.^g;
f = omega_q.^g_prime;

fprintf('生成基GCP (e,f)\n');
fprintf('基序列长度 M = %d，单位根阶数 q = %d\n', M, q);
disp('基序列 e：'); disp(e);
disp('基序列 f：'); disp(f);

v1 = 0;
v2 = q/2;      % 满足 v1-v2 = -q/2 ≡ q/2 (mod q)
v = 1;

fprintf('\n 设置参数\n');
fprintf('v1 = %d, v2 = %d, v = %d\n', v1, v2, v);
fprintf('参数约束验证：v1-v2 = %d (mod %d)，满足 ∈ {0, q/2}\n', mod(v1-v2, q), q);

% 生成4组完美CZCP
czcp_set = generate_czcp_set(e, f, q, v1, v2, v);
N = 2*M;       % 生成序列长度 N=2M
Z = M;         % 完美CZCP：Z=N/2（对应论文Definition 5）

fprintf('\n调用4组完美CZCP\n');
fprintf('生成序列长度 N = %d，零相关区宽度 Z = %d（完美CZCP）\n', N, Z);

% 验证
% 取第1组序列 (a1,b1) 进行验证
a1 = czcp_set(1).a;
b1 = czcp_set(1).b;

[tau_all, rho_ab1] = aperiodic_crosscorr(a1, b1);
[~, rho_ba1] = aperiodic_crosscorr(b1, a1);
ACC_sum = rho_ab1 + rho_ba1;

coeff_left = (-omega_q^(v1-v2) + omega_q^(v2-v1));

fprintf('\n验证构造证明\n');
fprintf('系数项：[-ω^(v1-v2) + ω^(v2-v1)] = %.4f\n', coeff_left);
if abs(coeff_left) < 1e-10
    fprintf('✅ 系数项为零！因此 ρ(a,b)(τ)+ρ(b,a)(τ) ≡ 0（对所有τ）\n');
end

% 检查尾端时延T2的ACC和（对应CZCP的C2条件）
idx_T2 = ismember(abs(tau_all), (N-Z):(N-1));
fprintf('尾端时延 T2 内的 ACC 和数值（应全为0）：\n');
disp(ACC_sum(idx_T2));

% 验证CZCP条件
[is_valid, results] = verify_czcp(a1, b1, Z);

fprintf('\n验证生成序列的CZCP条件\n');
if is_valid
    fprintf(' C1条件满足：AAC和在 |τ|∈T1∪T2 时为零\n');
    fprintf(' C2条件满足：ACC和在 |τ|∈T2 时为零\n');
else
    fprintf('验证失败\n');
end