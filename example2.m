clear; clc; close all;

Nt = 4;  % 实现说明。
M_SM = 8;  % 实现说明。
K = 4;  % 实现说明。
omega8 = exp(1i * 2 * pi / 8);  % 实现说明。

% 实现说明。
input_bits = [1 0 0 1 0;  % 实现说明。
              1 1 0 1 1;  % 实现说明。
              0 1 1 1 0;  % 实现说明。
              0 0 1 0 0];  % 实现说明。

% 实现说明。
D = zeros(Nt, K);

for k = 1:K
    % 实现说明。
    space_bits = input_bits(k, 1:2);  % 实现说明。
    const_bits = input_bits(k, 3:5);  % 实现说明。
    
    % 实现说明。
    n_k = bi2de(space_bits, 'left-msb') + 1;  % 实现说明。
    
    % 实现说明。
    const_idx = bi2de(const_bits, 'left-msb');  % 实现说明。
    S_k = omega8^const_idx;  % 实现说明。
    
    % 实现说明。
    d_k = zeros(Nt, 1);
    d_k(n_k) = S_k;  % 实现说明。
    
    % 实现说明。
    D(:, k) = d_k;
end

disp('Output');
disp('Output');
disp(input_bits);

disp(' ');
disp('Output');
for m = 0:M_SM-1
    fprintf('Output: %d, %d, %.4f, %.4f\n', m, m, real(omega8^m), imag(omega8^m));
end

disp(' ');
disp('Output');
disp(D);

% 实现说明。
figure;
spy(D, 10);  % 实现说明。
title('Experiment result');
xlabel('Index');
ylabel('Value');
