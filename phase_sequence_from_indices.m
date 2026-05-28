clear;
clc;

%% 参数设置
mu = 3;
q = 4;
g = [0, 1, 2, 3, 4, 5, 6, 7];

%% 将指数映射为相位符号
omega_q = exp(-1j * 2 * pi / q);
phi_q_g = omega_q .^ g;

%% 显示结果
disp(['mu = ', num2str(mu), ', length = ', num2str(2^mu)]);
disp(['q = ', num2str(q), ', primitive phase = ']);
disp(omega_q);
disp('Phase sequence:');
disp(phi_q_g);

phi_mag = abs(phi_q_g);
disp('Magnitudes:');
disp(phi_mag);

%% 备用指数序列
% len_g = 2^mu;
% g = 0:len_g - 1;
