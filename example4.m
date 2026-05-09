clearvars; close all; clc;

q = 4;                  % 4元序列
omega4 = exp(1i * 2 * pi / q); % ω4 = j
N = 9;                  % 序列长度
Z = 3;                  % 零相关区宽度
PI_CONST = 3.141592653589793;

exp_a = [0,1,1,2,0,2,1,1,3];  % a = ω4^exp_a
exp_b = [0,1,1,0,1,0,3,3,1];  % b = ω4^exp_b

% 转换为复数序列
a = omega4 .^ exp_a;
b = omega4 .^ exp_b;

fprintf('基础参数：\n');
fprintf('  序列长度 N = %d, 零相关区 Z = %d\n', N, Z);
fprintf('  原序列a指数：[%s]\n', num2str(exp_a));
fprintf('  原序列b指数：[%s]\n', num2str(exp_b));

% 论文定义：underline{x} 是序列x的反转（倒序）
a_rev = flip(a);  % 反转a
b_rev = flip(b);  % 反转b

% 生成论文中的序列：underline{b}^* 和 -underline{a}^*
b_rev_conj = conj(b_rev);       % b反转共轭
minus_a_rev_conj = -conj(a_rev);% -a反转共轭

% 转换为ω4的指数序列，和论文对比
exp_b_rev_conj = round(angle(b_rev_conj) / (2*PI_CONST/q));
exp_b_rev_conj(exp_b_rev_conj < 0) = exp_b_rev_conj(exp_b_rev_conj < 0) + q;

exp_minus_a_rev_conj = round(angle(minus_a_rev_conj) / (2*PI_CONST/q));
exp_minus_a_rev_conj(exp_minus_a_rev_conj < 0) = exp_minus_a_rev_conj(exp_minus_a_rev_conj < 0) + q;

% 论文Example 4给出的标准答案
paper_b_rev_conj = [3,1,1,0,3,0,3,3,0];
paper_minus_a_rev_conj = [3,1,1,0,2,0,1,1,2];

fprintf('underline{b}^* 生成：[%s]\n', num2str(exp_b_rev_conj));
fprintf('-underline{a}^* 生成：[%s]\n', num2str(exp_minus_a_rev_conj));

fprintf('\n【验证新序列对的自相关和】\n');
[tau_all, rho_bc] = aperiodic_autocorr(b_rev_conj);
[~, rho_mac] = aperiodic_autocorr(minus_a_rev_conj);
AAC_sum_new = rho_bc + rho_mac;
tau_pos = tau_all(tau_all >= 0);
AAC_sum_mag = abs(AAC_sum_new(tau_all >= 0));

fprintf('τ=0~8的AAC和模值：\n');
disp(AAC_sum_mag);%(18, 0,0,0, 2√2≈2.83, 2, 0,0,0)\n');

% 验证零相关区
T1 = 1:Z;
T2 = (N-Z):(N-1);
idx_C1 = ismember(tau_pos, [T1, T2]);
valid_C1_new = all(abs(AAC_sum_mag(idx_C1)) < 1e-10);
if valid_C1_new
    fprintf('新序列对满足C1条件，T1∪T2区间自相关和全为0\n');
end

fprintf('\n【验证原序列与新序列的正交性】\n');
[~, rho_a_bc] = aperiodic_crosscorr(a, b_rev_conj);
[~, rho_b_mac] = aperiodic_crosscorr(b, minus_a_rev_conj);
ACC_sum_orth = rho_a_bc + rho_b_mac;
ACC_sum_orth_mag = abs(ACC_sum_orth(tau_all >= 0));

fprintf('τ=0~8的互相关和模值最大值：%.2e\n', max(ACC_sum_orth_mag));%全0 (0_{1×9})\n';

valid_orth = all(abs(ACC_sum_orth_mag) < 1e-10);
if valid_orth
    fprintf('所有时延互相关和全为0\n');
end

fprintf('\n【验证新序列对的C2条件】\n');
[~, rho_bc_mac] = aperiodic_crosscorr(b_rev_conj, minus_a_rev_conj);
[~, rho_mac_bc] = aperiodic_crosscorr(minus_a_rev_conj, b_rev_conj);
ACC_sum_new = rho_bc_mac + rho_mac_bc;
ACC_sum_new_mag = abs(ACC_sum_new(tau_all >= 0));

fprintf('τ=0~8的ACC和模值：\n');
disp(ACC_sum_new_mag);%尾端τ=6~8全为0 (0_{1×3})\n';

% 验证尾端T2区间
idx_T2 = ismember(tau_pos, T2);
valid_C2_new = all(abs(ACC_sum_new_mag(idx_T2)) < 1e-10);
if valid_C2_new
    fprintf('新序列对满足C2条件，尾端T2区间互相关和全为0\n');
end

if valid_C1_new && valid_orth && valid_C2_new
    fprintf('  1. 新序列对是合法的(9,3)-CZCP\n');
    fprintf('  2. 与原CZCP完全正交\n');
else
    fprintf('部分验证项未通过\n');
end