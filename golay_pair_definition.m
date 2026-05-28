clearvars; clc;

a = [1, 1, 1, -1];
b = [1, 1, -1, 1];
N = length(a);
taus = 0:(N - 1);
tol = 1e-10;

[all_taus, all_rho_a] = aperiodic_autocorr(a);
[~, all_rho_b] = aperiodic_autocorr(b);
nonnegative_tau_mask = all_taus >= 0;

rho_a = all_rho_a(nonnegative_tau_mask);
rho_b = all_rho_b(nonnegative_tau_mask);
rho_sum = rho_a + rho_b;

zero_delay_ok = abs(rho_sum(1) - 2 * N) < tol;
nonzero_delay_ok = all(abs(rho_sum(2:end)) < tol);
pass = zero_delay_ok && nonzero_delay_ok;

fprintf('=== Example for verifying the definition of GCP ===\n');
fprintf('Sequence length N = %d\n\n', N);

fprintf('Sequence a:\n');
fprintf('a = [%s]\n\n', num2str(a));

fprintf('Sequence b:\n');
fprintf('b = [%s]\n\n', num2str(b));

fprintf('Aperiodic autocorrelation sum:\n');
for idx = 1:numel(taus)
    fprintf('tau = %d: rho(a) = %s, rho(b) = %s, sum = %s\n', ...
        taus(idx), format_scalar(rho_a(idx), tol), ...
        format_scalar(rho_b(idx), tol), format_scalar(rho_sum(idx), tol));
end

fprintf('\nGCP condition by delay:\n');
for idx = 1:numel(taus)
    if taus(idx) == 0
        delay_ok = abs(rho_sum(idx) - 2 * N) < tol;
    else
        delay_ok = abs(rho_sum(idx)) < tol;
    end
    fprintf('tau = %d: %s\n', taus(idx), pass_fail_label(delay_ok));
end

if pass
    fprintf('\nResult: PASS. The selected binary sequences form a Golay complementary pair.\n');
else
    fprintf('\nResult: FAIL. The selected binary sequences do not form a Golay complementary pair.\n');
end

% 保存可复用的表格数据。
save('golay_definition_results.mat', 'a', 'b', 'taus', 'rho_a', 'rho_b', 'rho_sum', 'pass');

function text = format_scalar(value, tol)
    if abs(imag(value)) < tol
        value = real(value);
    end

    if isreal(value) && abs(value - round(value)) < tol
        text = sprintf('%.0f', round(value));
    elseif isreal(value)
        text = sprintf('%.4g', value);
    else
        text = sprintf('%.4g %+.4gi', real(value), imag(value));
    end
end

function text = pass_fail_label(condition)
    if condition
        text = 'PASS';
    else
        text = 'FAIL';
    end
end
