clear; clc; close all;

Nt = 4;  % Implementation note.
M_SM = 8;  % Implementation note.
K = 4;  % Implementation note.
omega8 = exp(1i * 2 * pi / 8);  % Implementation note.

% Implementation note.
input_bits = [1 0 0 1 0;  % Implementation note.
              1 1 0 1 1;  % Implementation note.
              0 1 1 1 0;  % Implementation note.
              0 0 1 0 0];  % Implementation note.

% Implementation note.
D = zeros(Nt, K);

for k = 1:K
    % Implementation note.
    space_bits = input_bits(k, 1:2);  % Implementation note.
    const_bits = input_bits(k, 3:5);  % Implementation note.
    
    % Implementation note.
    n_k = bi2de(space_bits, 'left-msb') + 1;  % Implementation note.
    
    % Implementation note.
    const_idx = bi2de(const_bits, 'left-msb');  % Implementation note.
    S_k = omega8^const_idx;  % Implementation note.
    
    % Implementation note.
    d_k = zeros(Nt, 1);
    d_k(n_k) = S_k;  % Implementation note.
    
    % Implementation note.
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

% Implementation note.
figure;
spy(D, 10);  % Implementation note.
title('Experiment result');
xlabel('Index');
ylabel('Value');
