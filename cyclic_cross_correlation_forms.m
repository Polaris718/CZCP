clear;
clc;
close all;

N = 5;
% 单位模测试序列 a。
a = [1; 1i; -1; -1i; 1];
% 单位模测试序列 b。
b = [exp(1i*pi/4); exp(1i*3*pi/4); exp(1i*5*pi/4); exp(1i*7*pi/4); exp(1i*pi/4)];
tau = 2;

% 公式 (2) 的内积形式。
phi_inner = cyclic_cross_correlation(a, b, tau, 'inner');
% 公式 (2) 的显式求和形式。
phi_sum = cyclic_cross_correlation(a, b, tau, 'sum');

disp('================== Cyclic cross-correlation results ==================');
disp(['Inner-product result: ', num2str(phi_inner)]);
disp(['Summation result: ', num2str(phi_sum)]);
disp(['Absolute error between the two methods: ', num2str(abs(phi_inner - phi_sum))]);

if abs(phi_inner - phi_sum) < 1e-10
    disp('Verification passed: the two methods agree within numerical precision.');
else
    disp('Verification failed: the two methods do not agree.');
end
