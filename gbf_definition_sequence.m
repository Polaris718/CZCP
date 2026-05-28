clearvars;
clc;

q = 4;
m = 2;
N = 2^m;
omega = exp(2 * pi * 1i / q);

k_list = 0:(N - 1);
x_bits = zeros(N, m);
g_values = zeros(1, N);
sequence = zeros(1, N);

% 枚举所有二进制输入并计算 GBF 取值。
for idx = 1:N
    k = k_list(idx);
    x1 = bitget(k, m);
    x2 = bitget(k, 1);

    x_bits(idx, :) = [x1, x2];
    g_values(idx) = mod(2 * x1 * x2 + x1 + 3 * x2, q);
    sequence(idx) = omega ^ g_values(idx);
end

expected_g_values = [0, 3, 1, 2];
expected_sequence = omega .^ expected_g_values;
tol = 1e-10;
pass = isequal(g_values, expected_g_values) && all(abs(sequence - expected_sequence) < tol);

fprintf('=== Example for verifying the definition of GBF ===\n');
fprintf('q = %d, m = %d, N = %d\n', q, m, N);
fprintf('g(x1,x2) = 2*x1*x2 + x1 + 3*x2 mod 4\n\n');

fprintf('k   x1  x2  g_k   omega_4^{g_k}       s_k\n');
for idx = 1:N
    fprintf('%-3d %-3d %-3d %-5d %-20s %s\n', ...
        k_list(idx), x_bits(idx, 1), x_bits(idx, 2), g_values(idx), ...
        sprintf('omega_4^%d', g_values(idx)), format_complex(sequence(idx), tol));
end

if pass
    fprintf('\nResult: PASS. The generalized Boolean function is mapped to a 4-phase complex sequence.\n');
else
    fprintf('\nResult: FAIL. The generalized Boolean function mapping is inconsistent.\n');
end

% 保存指数序列及对应的多相复序列。
save('gbf_definition_results.mat', 'q', 'm', 'N', 'omega', ...
    'k_list', 'x_bits', 'g_values', 'sequence', 'pass');

function text = format_complex(value, tol)
    real_part = real(value);
    imag_part = imag(value);

    if abs(real_part) < tol
        real_part = 0;
    end
    if abs(imag_part) < tol
        imag_part = 0;
    end

    if imag_part < 0
        text = sprintf('%.4f - %.4fi', real_part, abs(imag_part));
    else
        text = sprintf('%.4f + %.4fi', real_part, imag_part);
    end
end
