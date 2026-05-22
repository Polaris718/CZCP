% 实现说明。
clear; clc;

%% 验证或构造步骤
mu = 3;  % 实现说明。
q = 4;  % 实现说明。
tau = 2;  % 实现说明。
% 实现说明。
g = 0 : 2^mu - 1;  % g = [0,1,2,3,4,5,6,7]
h = [0,2,4,6,1,3,5,7];  % 实现说明。


%% 验证或构造步骤
% 实现说明。
phi_q_g = gen_phi_q(g, q);
phi_q_h = gen_phi_q(h, q);

% 实现说明。
rho_q_gh = full_linear_cross_correlation(phi_q_g, phi_q_h, tau);

%% 验证或构造步骤
disp('Output');
disp(['Output', num2str(mu), ', q=', num2str(q), 'Output', num2str(tau)]);
disp('Output');
disp('Output'); disp(g);
disp('Output'); disp(h);
disp('Output');
disp(['Output', num2str(q), 'Output']); disp(phi_q_g);
disp(['Output', num2str(q), 'Output']); disp(phi_q_h);
disp('Output');
disp(['Output', num2str(q), '(g,h)(', num2str(tau), ') = ']);
disp(rho_q_gh);

% 实现说明。
test_taus = [-3, -1, 0, 2, 3];
disp('Output');
for t = test_taus
    rho_tmp = full_linear_cross_correlation(phi_q_g, phi_q_h, t);
    disp(['Output', num2str(t), 'Output', num2str(q), 'Output', num2str(rho_tmp)]);
end
