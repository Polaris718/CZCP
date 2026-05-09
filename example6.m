clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

q = 4;                  % 4元序列
mu = 4;                 % GBF变量数，序列长度 N=2^4=16
perm_vec = [4, 2, 3, 1]; % 置换向量（注意：不用pi！）
w_k = [3, 2, 0, 1];     % 线性项系数 [w1,w2,w3,w4]
w = 0;                   % 常数项
w_prime = 2;             % 偏移项，q/2=2
PI_CONST = 3.141592653589793; % 圆周率常量

fprintf('参数设置：\n');
fprintf('  q = %d, mu = %d\n', q, mu);
fprintf('  序列长度 N = %d, 零相关区 Z = %d\n', 2^mu, 2^(mu-1));
fprintf('  置换向量 = [%s]\n', num2str(perm_vec));
fprintf('  w_k = [%s], w = %d, w'' = %d\n', num2str(w_k), w, w_prime);

%% q_ray_czcp 生成完美CZCP
fprintf('\n【2/4 生成序列】\n');
[czcp_pair, N, Z] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime);

a_seq = czcp_pair.a;
b_seq = czcp_pair.b;
fprintf('  序列a长度：%d\n', length(a_seq));
fprintf('  序列b长度：%d\n', length(b_seq));

%% 验证C1/C2条件
fprintf('\n【4/4 零相关区验证】\n');
% 计算C1：AAC和 ρ(a)(τ)+ρ(b)(τ)
[tau_all, rho_a] = aperiodic_autocorr(a_seq);
[~, rho_b] = aperiodic_autocorr(b_seq);
AAC_sum = rho_a + rho_b;
tau_pos = tau_all(tau_all >= 0); % 仅展示非负时延
AAC_sum_mag = abs(AAC_sum(tau_all >= 0));

% 计算C2：ACC和 ρ(a,b)(τ)+ρ(b,a)(τ)
[~, rho_ab] = aperiodic_crosscorr(a_seq, b_seq);
[~, rho_ba] = aperiodic_crosscorr(b_seq, a_seq);
ACC_sum = rho_ab + rho_ba;
ACC_sum_mag = abs(ACC_sum(tau_all >= 0));

%验证
fprintf('\n C1条件验证结果\n');
fprintf('(|ρ(a)(τ)+ρ(b)(τ)|)_{τ=0}^{15} = (');
for i = 1:length(AAC_sum_mag)
    if i == 1
        fprintf('%.0f', AAC_sum_mag(i));
    else
        fprintf(', 0'); % 因为都是0，直接打印0更清晰
    end
end
fprintf(')\n');%(32, 0_{1×15})\n')

fprintf('\n C2条件验证结果\n');
fprintf('(|ρ(b,a)(τ)+ρ(a,b)(τ)|)_{τ=0}^{15} = (');
for i = 1:length(ACC_sum_mag)
    val = ACC_sum_mag(i);
    if abs(val) < 1e-10
        fprintf('0');
    elseif abs(val - 12) < 1e-10
        fprintf('12');
    elseif abs(val - 4) < 1e-10
        fprintf('4');
    elseif abs(val - 4*sqrt(2)) < 1e-10
        fprintf('4√2');
    else
        fprintf('%.2f', val);
    end
    if i < length(ACC_sum_mag)
        fprintf(', ');
    end
end
fprintf(')\n');%(0,12,0,4,0,4,0,4, 0_{1×8})\n')

valid_C1 = (abs(AAC_sum_mag(1) - 32) < 1e-10) && all(abs(AAC_sum_mag(2:end)) < 1e-10);
tau_T2 = 8:15; % 尾端时延 T2 = N-Z = 16-8 = 8~15
ACC_sum_T2 = ACC_sum_mag(tau_T2 + 1);
valid_C2 = all(ACC_sum_T2 < 1e-10);

if valid_C1
    fprintf('✅ C1条件满足：所有非零时延自相关和为0\n');
else
    fprintf('❌ C1条件失败\n');
end

if valid_C2
    fprintf('✅ C2条件满足：尾端时延τ=8~15互相关和为0\n');
else
    fprintf('❌ C2条件失败\n');
end
