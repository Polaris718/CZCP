clear;
clc;
close all;

Nt = 4;
M_SM = 8;
K = 4;
omega8 = exp(1i * 2 * pi / 8);

% 每行包含 2 个天线索引比特和 3 个星座比特。
input_bits = [
    1 0 0 1 0;
    1 1 0 1 1;
    0 1 1 1 0;
    0 0 1 0 0
];

D = zeros(Nt, K);

for k = 1:K
    space_bits = input_bits(k, 1:2);
    const_bits = input_bits(k, 3:5);

    n_k = bi2de(space_bits, 'left-msb') + 1;
    const_idx = bi2de(const_bits, 'left-msb');
    S_k = omega8^const_idx;

    d_k = zeros(Nt, 1);
    d_k(n_k) = S_k;
    D(:, k) = d_k;
end

disp('Input bits:');
disp(input_bits);

disp('8-PSK constellation mapping:');
for m = 0:M_SM-1
    fprintf('index=%d, symbol=%.4f%+.4fi\n', m, real(omega8^m), imag(omega8^m));
end

disp('Sparse spatial-modulation symbol matrix D:');
disp(D);

figure;
spy(D, 10);
title('Sparse SM Symbol Matrix');
xlabel('Symbol index');
ylabel('Transmit antenna');
