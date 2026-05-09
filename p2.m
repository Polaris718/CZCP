clear; clc; close all;


N = 9; Z = 3;
omega4 = exp(1i * 2 * pi / 4); % 4次单位根

% Example 3: 原始 (9,3)-CZCP (a, b)
a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];

b_rev_conj_paper = omega4.^[3, 1, 1, 0, 3, 0, 3, 3, 0];
a_rev_conj_neg_paper = omega4.^[3, 1, 1, 0, 2, 0, 1, 1, 2];

% 定义时延集合
T1 = 1:Z;
T2 = (N-Z):(N-1);
tau_all = -(N-1):(N-1);

% ---------- 2. 验证P2第一部分：(c1*b, c2*a) 仍是CZCP ----------
% 选取 c1 = 1, c2 = 1 (最简单的变换)
c1 = 1;
c2 = 1;
a_new = c1 * b;
b_new = c2 * a;

% 计算新序列对的相关值
[~, rho_a_new] = aperiodic_autocorr(a_new);
[~, rho_b_new] = aperiodic_autocorr(b_new);
[~, rho_ab_new] = aperiodic_crosscorr(a_new, b_new);
[~, rho_ba_new] = aperiodic_crosscorr(b_new, a_new);

% 验证条件
idx_C1 = ismember(abs(tau_all), [T1, T2]);
idx_C2 = ismember(abs(tau_all), T2);

C1_check = rho_a_new(idx_C1) + rho_b_new(idx_C1);
C2_check = rho_ab_new(idx_C2) + rho_ba_new(idx_C2);

cond_p2_1 = all(abs(C1_check) < 1e-10) && all(abs(C2_check) < 1e-10);

% ---------- 3. 验证P2第二部分：基于Example 4的互相关 ----------
% 这里我们直接验证论文中给出的结论 (Example 4的文字描述)
% 即：(b_rev_conj_paper, a_rev_conj_neg_paper) 这对序列

% 3.1 验证它们的 AAC sum 为零 (对应论文式21第一行)
[~, rho_brc] = aperiodic_autocorr(b_rev_conj_paper);
[~, rho_arcn] = aperiodic_autocorr(a_rev_conj_neg_paper);
AAC_sum = rho_brc + rho_arcn;

% 3.2 验证原序列与新序列的 ACC sum 为零 (对应论文式21第二行，全τ为零)
[~, rho_a_brc] = aperiodic_crosscorr(a, b_rev_conj_paper);
[~, rho_b_arcn] = aperiodic_crosscorr(b, a_rev_conj_neg_paper);
ACC_sum_1 = rho_a_brc + rho_b_arcn;

% 3.3 验证另一个互相关条件 (对应论文式21第三行，|τ|∈T2为零)
[~, rho_b_brc] = aperiodic_crosscorr(b, b_rev_conj_paper);
[~, rho_a_arcn] = aperiodic_crosscorr(a, a_rev_conj_neg_paper);
ACC_sum_2 = rho_b_brc + rho_a_arcn;

% 检查结果
cond_p2_2 = all(abs(AAC_sum(idx_C1)) < 1e-10); % 验证AAC sum在ZCZ为零
cond_p2_3 = all(abs(ACC_sum_1) < 1e-10);       % 验证式21第二行全τ为零
cond_p2_4 = all(abs(ACC_sum_2(idx_C2)) < 1e-10); % 验证式21第三行尾端为零

% ---------- 4. 结果显示 ----------
disp('================== 性质P2验证结果 ==================');

if cond_p2_1
    disp('✅ 验证通过：(c1*b, c2*a) 仍是CZCP');
else
    disp('❌ 验证失败');
end

if cond_p2_2
    disp('✅ 验证通过：新序列对的 AAC sum 在 ZCZ 内为零');
end

if cond_p2_3
    disp('✅ 验证通过：ρ(a, b*) + ρ(b, -a*) = 0 (对所有τ)');
end

if cond_p2_4
    disp('✅ 验证通过：ρ(b, b*) + ρ(a, -a*) = 0 (对|τ|∈T2)');
end

if cond_p2_1 && cond_p2_2 && cond_p2_3 && cond_p2_4
    disp(' ');
    disp('🎉 所有性质P2的条件均验证通过！');
end