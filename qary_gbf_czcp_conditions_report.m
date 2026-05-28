clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

q = 4;
mu = 4;
perm_vec = [4, 2, 3, 1];
w_k = [3, 2, 0, 1];
w = 0;
w_prime = 2;

fprintf('Example 6 parameter setup:\n');
fprintf('  q = %d, mu = %d\n', q, mu);
fprintf('  Sequence length N = %d, zero-correlation zone Z = %d\n', 2^mu, 2^(mu-1));
fprintf('  Permutation vector = [%s]\n', num2str(perm_vec));
fprintf('  w_k = [%s], w = %d, w'' = %d\n', num2str(w_k), w, w_prime);

fprintf('\n[1/3] Generate CZCP sequences\n');
[czcp_pair, N, Z] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime);

a_seq = czcp_pair.a;
b_seq = czcp_pair.b;
fprintf('  Sequence a length: %d\n', length(a_seq));
fprintf('  Sequence b length: %d\n', length(b_seq));

fprintf('\n[2/3] Compute correlation sums\n');
[tau_all, rho_a] = aperiodic_autocorr(a_seq);
[~, rho_b] = aperiodic_autocorr(b_seq);
AAC_sum = rho_a + rho_b;
AAC_sum_mag = abs(AAC_sum(tau_all >= 0));

[~, rho_ab] = aperiodic_crosscorr(a_seq, b_seq);
[~, rho_ba] = aperiodic_crosscorr(b_seq, a_seq);
ACC_sum = rho_ab + rho_ba;
ACC_sum_mag = abs(ACC_sum(tau_all >= 0));

fprintf('\nC1 autocorrelation-sum magnitudes for tau = 0:%d:\n', N - 1);
print_integer_like_vector(AAC_sum_mag);

fprintf('\nC2 cross-correlation-sum magnitudes for tau = 0:%d:\n', N - 1);
print_integer_like_vector(ACC_sum_mag);

fprintf('\n[3/3] Verify zero-correlation-zone conditions\n');
valid_C1 = (abs(AAC_sum_mag(1) - 2 * N) < 1e-10) && all(abs(AAC_sum_mag(2:end)) < 1e-10);
tau_T2 = Z:(N - 1);
ACC_sum_T2 = ACC_sum_mag(tau_T2 + 1);
valid_C2 = all(ACC_sum_T2 < 1e-10);

if valid_C1
    fprintf('C1 condition passed: autocorrelation sums vanish for all nonzero delays.\n');
else
    fprintf('C1 condition failed: nonzero autocorrelation residuals were found.\n');
end

if valid_C2
    fprintf('C2 condition passed: cross-correlation sums vanish for tail delays tau = %d:%d.\n', Z, N - 1);
else
    fprintf('C2 condition failed: nonzero cross-correlation residuals were found in the tail zone.\n');
end

function print_integer_like_vector(values)
    fprintf('(');
    for idx = 1:length(values)
        val = values(idx);
        if abs(val) < 1e-10
            fprintf('0');
        elseif abs(val - round(val)) < 1e-10
            fprintf('%.0f', round(val));
        else
            fprintf('%.4g', val);
        end
        if idx < length(values)
            fprintf(', ');
        end
    end
    fprintf(')\n');
end
