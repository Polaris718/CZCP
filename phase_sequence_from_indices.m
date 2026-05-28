% 实现说明。
clear; clc;

%% 验证或构造步骤
mu = 3;  % 实现说明。
q = 4;  % 实现说明。
% 实现说明。
g = [0, 1, 2, 3, 4, 5, 6, 7];

%% 验证或构造步骤
% 实现说明。
omega_q = exp(-1j * 2 * pi / q);

% 实现说明。
phi_q_g = omega_q .^ g;

%% 验证或构造步骤
disp('Output');
disp(['Output', num2str(mu), 'Output', num2str(2^mu)]);
disp(['Output', num2str(q), 'Output', num2str(q), ' = ']);
disp(omega_q);
disp(['Output', num2str(q), 'Output']);
disp(phi_q_g);

% 实现说明。
phi_mag = abs(phi_q_g);
disp('Output');
disp(phi_mag);

%% 验证或构造步骤
% len_g = 2^mu;
% g = 0 : len_g - 1;
