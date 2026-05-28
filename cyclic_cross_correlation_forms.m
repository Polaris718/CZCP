clear;
clc;
close all;

N = 5;
% Unit-magnitude test sequence a.
a = [1; 1i; -1; -1i; 1];
% Unit-magnitude test sequence b.
b = [exp(1i*pi/4); exp(1i*3*pi/4); exp(1i*5*pi/4); exp(1i*7*pi/4); exp(1i*pi/4)];
tau = 2;

% Formula (2), inner-product form.
phi_inner = cyclic_cross_correlation(a, b, tau, 'inner');
% Formula (2), explicit summation form.
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
