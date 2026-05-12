clear; clc;

N = 8;
a = exp(1i * 2 * pi * rand(N, 1));
b = exp(1i * 2 * pi * rand(N, 1));

disp('=== Test sequence information ===');
fprintf('Sequence length N = %d\n', N);

disp('Random unit-modulus sequence a:');
for idx = 1:N
    fprintf('a(%d) = %.4f %+.4fi  (|a|=%.4f)\n', ...
        idx - 1, real(a(idx)), imag(a(idx)), abs(a(idx)));
end

disp(' ');
disp('Random unit-modulus sequence b:');
for idx = 1:N
    fprintf('b(%d) = %.4f %+.4fi  (|b|=%.4f)\n', ...
        idx - 1, real(b(idx)), imag(b(idx)), abs(b(idx)));
end

test_taus = [-8, -5, -2, 0, 1, 3, 7, 8];

disp(' ');
disp('=== Formula (1) aperiodic cross-correlation verification ===');
for tau = test_taus
    rho = full_linear_cross_correlation(a, b, tau);

    if abs(tau) >= N
        delay_type = 'outside valid nonzero range';
    elseif tau > 0
        delay_type = 'positive delay';
    elseif tau < 0
        delay_type = 'negative delay';
    else
        delay_type = 'zero delay';
    end

    fprintf('tau=%2d (%s): rho(a,b)(tau) = %.6f %+.6fi\n', ...
        tau, delay_type, real(rho), imag(rho));
end
