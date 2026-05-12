clear; clc; close all;

N = 5;
% Sequence a has unit-modulus entries.
a = [1; 1i; -1; -1i; 1];
% Sequence b has unit-modulus entries.
b = [exp(1i*pi/4); exp(1i*3*pi/4); exp(1i*5*pi/4); exp(1i*7*pi/4); exp(1i*pi/4)];
% Test delay.
tau = 2;

% Inner-product form of formula (2).
phi_inner = cyclic_cross_correlation(a, b, tau, 'inner');
% Summation form of formula (2).
phi_sum = cyclic_cross_correlation(a, b, tau, 'sum');

disp('================== Cyclic cross-correlation results ==================');
disp(['Inner-product result: ', num2str(phi_inner)]);
disp(['Summation result: ', num2str(phi_sum)]);
disp(['Absolute error between the two methods: ', num2str(abs(phi_inner - phi_sum))]);

% Consistency check.
if abs(phi_inner - phi_sum) < 1e-10
    disp('Verification passed: the two methods agree within numerical precision.');
else
    disp('Verification failed: the two methods do not agree.');
end
