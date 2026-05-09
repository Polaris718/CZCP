% 公式(8)：计算ρ_q(g,h)(τ) = ρ(φ_q(g), φ_q(h))(τ)
clear; clc;

%% 自定义基础参数
mu = 3;          % 向量g/h的长度参数：2^mu=8
q = 4;           % q次单位根参数
tau = 2;         % 延迟值（可改为任意整数，如-3/0/5等）
% 定义公式(6)的向量g和h（长度=2^mu）
g = 0 : 2^mu - 1;  % g = [0,1,2,3,4,5,6,7]
h = [0,2,4,6,1,3,5,7];  % 自定义h向量（长度需与g一致）


%% 公式(8)计算
% 步骤1：生成复指数向量φ_q(g)、φ_q(h)（公式7）
phi_q_g = gen_phi_q(g, q);
phi_q_h = gen_phi_q(h, q);

% 步骤2：计算线性互相关ρ(φ_q(g), φ_q(h))(τ)（公式1）
rho_q_gh = full_linear_cross_correlation(phi_q_g, phi_q_h, tau);

%%结果
disp('=== 公式(8) - ρ_q(g,h)(τ)计算结果 ===');
disp(['基础参数：μ=', num2str(mu), ', q=', num2str(q), ', τ=', num2str(tau)]);
disp('--- 公式(6)的原始向量 ---');
disp('向量g：'); disp(g);
disp('向量h：'); disp(h);
disp('--- 公式(7)的复指数向量 ---');
disp(['φ_', num2str(q), '(g)：']); disp(phi_q_g);
disp(['φ_', num2str(q), '(h)：']); disp(phi_q_h);
disp('--- 公式(8)的最终结果 ---');
disp(['ρ_', num2str(q), '(g,h)(', num2str(tau), ') = ']);
disp(rho_q_gh);

% 可验证多个延迟值的结果
test_taus = [-3, -1, 0, 2, 3];
disp('--- 多延迟值验证 ---');
for t = test_taus
    rho_tmp = full_linear_cross_correlation(phi_q_g, phi_q_h, t);
    disp(['τ=', num2str(t), ' → ρ_', num2str(q), '(g,h)(τ) = ', num2str(rho_tmp)]);
end