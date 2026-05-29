clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

% CZCP-SM 训练实验驱动脚本。

Nt = 4;
J = 2;               % 训练重复因子
lambda = 7;
channel_len = lambda + 1;
q = 4;
mu = 4;  % CZCP 参数。
perm_vec = [4, 2, 3, 1];
w_k = [3, 2, 0, 1];
w = 0;
w_prime = 2;
seed_type = 2;

[czcp_pair, theta, Z] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime);
a = czcp_pair.a;
b = czcp_pair.b;

[is_perfect, czcp_results] = perfect_czcp_condition_check(a, b);
fprintf('Perfect CZCP check: %d, theta=%d, Z=%d\n', is_perfect, theta, Z);
fprintf('CZCP max C1 residual: %.2e\n', max(abs(czcp_results.C1_vals)));
fprintf('CZCP max C2 residual: %.2e\n', max(abs(czcp_results.C2_vals)));

Omega_czcp = build_czcp_sm_training(a, b, Nt, J, seed_type);
Omega_random = build_random_sm_training(Nt, theta, J, q);

snr_db = 0:5:30;
mse_czcp = zeros(size(snr_db));
mse_random = zeros(size(snr_db));
bound = zeros(size(snr_db));
gram_err_czcp = 0;
gram_err_random = 0;

for idx = 1:length(snr_db)
    noise_var = 10^(-snr_db(idx) / 10);

    metrics_czcp = training_mse_metrics(Omega_czcp, channel_len, noise_var);
    metrics_random = training_mse_metrics(Omega_random, channel_len, noise_var);

    mse_czcp(idx) = metrics_czcp.normalized_mse;
    mse_random(idx) = metrics_random.normalized_mse;
    bound(idx) = metrics_czcp.lower_bound;

    if idx == 1
        gram_err_czcp = metrics_czcp.gram_error_max;
        gram_err_random = metrics_random.gram_error_max;
        fprintf('CZCP Gram max error to E*I: %.2e\n', gram_err_czcp);
        fprintf('Random Gram max error to E*I: %.2e\n', gram_err_random);
        fprintf('Per-antenna energy E: %.0f\n', metrics_czcp.energy_per_antenna);
    end
end

results = struct();
results.Nt = Nt;
results.J = J;
results.lambda = lambda;
results.channel_len = channel_len;
results.theta = theta;
results.Z = Z;
results.snr_db = snr_db;
results.mse_czcp = mse_czcp;
results.mse_random = mse_random;
results.bound = bound;
results.gram_err_czcp = gram_err_czcp;
results.gram_err_random = gram_err_random;
save('training_mse_experiment_results.mat', 'results');

figure('Color', 'w', 'Position', [100, 100, 1050, 720]);
ax = axes;
plot_training_mse_axes(ax, snr_db, mse_czcp, bound, mse_random);
grid on;
xlabel('SNR (dB)');
ylabel('Normalized MSE');
legend('CZCP training', 'Lower bound', 'Random same-support training', 'Location', 'southwest');
title('CZCP-SM Training MSE Experiment');
add_training_mse_inset(ax, snr_db, mse_czcp, bound, mse_random);
saveas(gcf, 'training_mse_experiment.png');

fprintf('\nMSE table:\n');
fprintf('SNR(dB)   CZCP-MSE        Bound           Random-MSE\n');
for idx = 1:length(snr_db)
    fprintf('%6.1f   %.4e   %.4e   %.4e\n', snr_db(idx), mse_czcp(idx), bound(idx), mse_random(idx));
end

function plot_training_mse_axes(ax, snr_db, mse_czcp, bound, mse_random)
    axes(ax);
    semilogy(snr_db, mse_czcp, 'o-', ...
        'Color', [0, 0, 0], 'LineWidth', 1.9, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w'); hold on;
    semilogy(snr_db, bound, 'k:', ...
        'LineWidth', 1.8, 'Marker', 'x', 'MarkerSize', 8);
    semilogy(snr_db, mse_random, 's--', ...
        'Color', [0.35, 0.35, 0.35], 'LineWidth', 1.8, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w');
end

function add_training_mse_inset(parent_ax, snr_db, mse_czcp, bound, mse_random)
    pos = parent_ax.Position;
    inset_pos = [pos(1) + 0.56 * pos(3), pos(2) + 0.55 * pos(4), ...
        0.34 * pos(3), 0.34 * pos(4)];
    inset_ax = axes('Position', inset_pos);
    plot_training_mse_axes(inset_ax, snr_db, mse_czcp, bound, mse_random);
    high_snr_mask = snr_db >= max(snr_db) - 10;
    y_focus = [mse_czcp(high_snr_mask), bound(high_snr_mask)];
    xlim([max(snr_db) - 10, max(snr_db)]);
    ylim([0.85 * min(y_focus(:)), 1.25 * max(y_focus(:))]);
    grid on;
    set(gca, 'FontSize', 9, 'Box', 'on');
    xlabel('');
    ylabel('');
    title('Zoom', 'FontSize', 9);
    axes(parent_ax);
end
