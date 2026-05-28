clear; clc;

N = 4;
rng('shuffle');

base_a = [1; 1; 1; -1];
base_b = [1; 1; -1; 1];

phase_a = exp(1i * 2 * pi * rand);
phase_b = exp(1i * 2 * pi * rand);

a = phase_a * base_a;
b = phase_b * base_b;

if rand > 0.5
    a = flipud(conj(a));
    b = flipud(conj(b));
end

if rand > 0.5
    tmp = a;
    a = b;
    b = tmp;
end

fprintf('=== Formula (4) verification with a random unit-modulus GCP ===\n');
fprintf('Sequence length N = %d\n', N);

fprintf('\nSequence a:\n');
for idx = 1:N
    fprintf('a(%d) = %.6f %+.6fi, |a| = %.6f\n', ...
        idx - 1, real(a(idx)), imag(a(idx)), abs(a(idx)));
end

fprintf('\nSequence b:\n');
for idx = 1:N
    fprintf('b(%d) = %.6f %+.6fi, |b| = %.6f\n', ...
        idx - 1, real(b(idx)), imag(b(idx)), abs(b(idx)));
end

fprintf('\nAutocorrelation sum over all delays tau in [0, 3]:\n');
is_gcp = true;
for tau = 0:N-1
    rho_a = linear_autocorrelation(a, tau);
    rho_b = linear_autocorrelation(b, tau);
    sum_rho = rho_a + rho_b;
    if tau ~= 0 && abs(sum_rho) >= 1e-10
        is_gcp = false;
    end

    fprintf('tau = %d: rho(a) + rho(b) = %.6f %+.6fi, |sum| = %.6e\n', ...
        tau, real(sum_rho), imag(sum_rho), abs(sum_rho));
end

if is_gcp
    fprintf('\nResult: PASS. The randomly generated unit-modulus sequences form a Golay complementary pair.\n');
else
    fprintf('\nResult: FAIL. The generated sequences do not satisfy the Golay complementary property.\n');
end
