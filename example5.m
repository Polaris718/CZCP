clear; clc; close all;

q = 4;                  % 4元序列
omega4 = exp(1i*2*pi/q); % ω4 = j
M = 11;                 % 基序列长度
N = 2*M;                % 生成CZCP长度 N=22
Z = M;                  % 完美CZCP零相关区 Z=11

% GCP (e,f)的指数序列
exp_e = [0, 1, 2, 0, 2, 1, 3, 2, 1, 1, 0];
exp_f = [0, 0, 3, 3, 3, 0, 0, 1, 2, 0, 2];

% 生成基序列 e = ω4^exp_e, f = ω4^exp_f
e = omega4.^exp_e;
f = omega4.^exp_f;

v1 = 0;
v2 = 0;
v = 1;

fprintf('【输入参数】\n');
fprintf('单位根阶数 q = %d，基序列长度 M = %d\n', q, M);
fprintf('相位参数 v1 = %d, v2 = %d, v = %d\n', v1, v2, v);
fprintf('参数约束验证：v1-v2 = %d，满足 ∈ {0, q/2}\n', v1-v2);

% 调用函数生成完美CZCP
czcp_set = generate_czcp_set(e, f, q, v1, v2, v);
a1 = czcp_set(1).a; % Example 5仅展示第1组序列
b1 = czcp_set(1).b;

% 验证生成的序列指数
% 注意：因MATLAB浮点误差，用angle()计算相位后归一化到[0,3]
exp_a1 = round(angle(a1)/(2*pi/q)); 
exp_a1(exp_a1<0) = exp_a1(exp_a1<0) + q; % 处理负相位
exp_b1 = round(angle(b1)/(2*pi/q));
exp_b1(exp_b1<0) = exp_b1(exp_b1<0) + q;

fprintf('\n【生成序列】\n');
fprintf('生成完美CZCP 序列a的指数：\n');
disp(exp_a1);
fprintf('生成完美CZCP 序列b的指数：\n');
disp(exp_b1);

% 验证C1条件：AAC和 ρ(a)(τ)+ρ(b)(τ)
[tau_all, rho_a] = aperiodic_autocorr(a1);
[~, rho_b] = aperiodic_autocorr(b1);
AAC_sum = rho_a + rho_b;

% 取 τ=0 到 21 的模值（论文仅展示非负时延）
tau_pos = 0:N-1;
AAC_sum_mag = abs(AAC_sum(tau_all >= 0));

fprintf('\n【C1条件验证】ρ(a)(τ)+ρ(b)(τ) 的模值（τ=0到21）：\n');
disp(AAC_sum_mag);
if abs(AAC_sum_mag(1) - 44) < 1e-10 && all(abs(AAC_sum_mag(2:end)) < 1e-10)
    fprintf('✅ C1条件验证通过。\n');
end

% 验证C2条件：ACC和 ρ(a,b)(τ)+ρ(b,a)(τ)
[~, rho_ab] = aperiodic_crosscorr(a1, b1);
[~, rho_ba] = aperiodic_crosscorr(b1, a1);
ACC_sum = rho_ab + rho_ba;
ACC_sum_mag = abs(ACC_sum(tau_all >= 0));

fprintf('\n【C2条件验证】ρ(a,b)(τ)+ρ(b,a)(τ) 的模值（τ=0到21）：\n');
disp(ACC_sum_mag);

% 检查尾端11个时延（τ=11到21）是否全为0
tau_T2 = 11:21;
ACC_sum_T2 = ACC_sum_mag(tau_T2+1); % MATLAB索引从1开始
if all(abs(ACC_sum_T2) < 1e-10)
    fprintf('✅ C2条件验证通过。尾端时延 T2 (τ=11~21) 内的ACC和全为0\n');
end