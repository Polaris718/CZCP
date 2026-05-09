clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

% Monte Carlo verification for the Section IV CZCP-SM training experiment.
% The theoretical LS-MSE curves are computed from X'X. The empirical curves
% estimate random channels over many trials and compare h_hat against h.

rng(11);

Nt = 4;
J = 2;
lambda = 7;
channel_len = lambda + 1;
q = 4;
mu = 4;
perm_vec = [4, 2, 3, 1];
w_k = [3, 2, 0, 1];
w = 0;
w_prime = 2;
seed_type = 2;

snr_db = 0:5:30;
num_trials = 500;

[czcp_pair, theta] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime);
Omega_czcp = build_czcp_sm_training(czcp_pair.a, czcp_pair.b, Nt, J, seed_type);
Omega_random = build_random_sm_training(Nt, theta, J, q);

X_czcp = build_training_matrix(Omega_czcp, channel_len);
X_random = build_training_matrix(Omega_random, channel_len);

results = struct();
results.Nt = Nt;
results.J = J;
results.lambda = lambda;
results.channel_len = channel_len;
results.theta = theta;
results.snr_db = snr_db;
results.num_trials = num_trials;
results.theory_czcp = zeros(size(snr_db));
results.theory_random = zeros(size(snr_db));
results.empirical_czcp = zeros(size(snr_db));
results.empirical_random = zeros(size(snr_db));
results.bound = zeros(size(snr_db));

fprintf('Running Monte Carlo LS channel simulation (%d trials per SNR)...\n', num_trials);
for idx = 1:length(snr_db)
    noise_var = 10^(-snr_db(idx) / 10);

    metrics_czcp = training_mse_metrics(Omega_czcp, channel_len, noise_var);
    metrics_random = training_mse_metrics(Omega_random, channel_len, noise_var);

    results.theory_czcp(idx) = metrics_czcp.normalized_mse;
    results.theory_random(idx) = metrics_random.normalized_mse;
    results.bound(idx) = metrics_czcp.lower_bound;
    results.empirical_czcp(idx) = empirical_ls_mse(X_czcp, noise_var, num_trials);
    results.empirical_random(idx) = empirical_ls_mse(X_random, noise_var, num_trials);

    fprintf('SNR=%4.1f dB  CZCP empirical=%.4e  theory=%.4e\n', ...
        snr_db(idx), results.empirical_czcp(idx), results.theory_czcp(idx));
end

save('monte_carlo_channel_results.mat', 'results');

figure('Color', 'w');
semilogy(snr_db, results.theory_czcp, 'o-', 'LineWidth', 1.6); hold on;
semilogy(snr_db, results.empirical_czcp, 'o--', 'LineWidth', 1.6);
semilogy(snr_db, results.bound, 'k:', 'LineWidth', 1.4);
semilogy(snr_db, results.theory_random, 's-', 'LineWidth', 1.6);
semilogy(snr_db, results.empirical_random, 's--', 'LineWidth', 1.6);
grid on;
xlabel('SNR (dB)');
ylabel('Normalized MSE');
legend('CZCP theory', 'CZCP Monte Carlo', 'Lower bound', ...
    'Random theory', 'Random Monte Carlo', 'Location', 'southwest');
title('Monte Carlo LS Channel Estimation Verification');
saveas(gcf, '蒙特卡洛_信道估计MSE验证.png');

fprintf('Saved:\n');
fprintf('  monte_carlo_channel_results.mat\n');
fprintf('  蒙特卡洛_信道估计MSE验证.png\n');

function mse = empirical_ls_mse(X, noise_var, num_trials)
    num_params = size(X, 2);
    mse_accum = 0;
    gram = X' * X;

    for trial = 1:num_trials
        h = (randn(num_params, 1) + 1i * randn(num_params, 1)) / sqrt(2);
        noise = sqrt(noise_var / 2) * ...
            (randn(size(X, 1), 1) + 1i * randn(size(X, 1), 1));
        y = X * h + noise;
        h_hat = gram \ (X' * y);
        mse_accum = mse_accum + norm(h_hat - h)^2 / num_params;
    end

    mse = real(mse_accum / num_trials);
end
