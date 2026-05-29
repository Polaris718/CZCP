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
        'Color', [0.0000, 0.4470, 0.7410], 'LineWidth', 1.9, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w'); hold on;
    semilogy(snr_db, bound, 'x:', ...
        'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.8, ...
        'MarkerSize', 8);
    semilogy(snr_db, mse_random, 's--', ...
        'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 1.8, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w');
end

function add_training_mse_inset(parent_ax, snr_db, mse_czcp, bound, mse_random)
    data_x = repmat(snr_db(:), 3, 1);
    data_y = [mse_czcp(:); bound(:); mse_random(:)];
    inset_pos = choose_inset_position(parent_ax, data_x, data_y, 0.34, 0.34);
    inset_ax = axes('Position', inset_pos);
    plot_training_mse_axes(inset_ax, snr_db, mse_czcp, bound, mse_random);
    high_snr_mask = snr_db >= max(snr_db) - 5;
    y_focus = [mse_czcp(high_snr_mask), bound(high_snr_mask)];
    xlim([max(snr_db) - 5, max(snr_db)]);
    y_min = min(y_focus(:));
    y_max = max(y_focus(:));
    ylim([max(y_min / 1.25, eps), y_max * 1.25]);
    grid on;
    set(gca, 'FontSize', 9, 'Box', 'on');
    xlabel('');
    ylabel('');
    title('Zoom', 'FontSize', 9);
    uistack(inset_ax, 'top');
end

function inset_pos = choose_inset_position(parent_ax, data_x, data_y, inset_w, inset_h)
    pos = parent_ax.Position;
    if pos(3) > 0.55 && ~isa(parent_ax.Parent, 'matlab.graphics.layout.TiledChartLayout')
        gap = 0.025;
        inset_w_fig = 0.24;
        inset_h_fig = 0.30;
        new_width = max(0.50, pos(3) - inset_w_fig - gap);
        parent_ax.Position = [pos(1), pos(2), new_width, pos(4)];
        inset_pos = [pos(1) + new_width + gap, ...
            pos(2) + pos(4) - inset_h_fig, inset_w_fig, inset_h_fig];
        return;
    end

    data_x = densify_for_overlap(data_x);
    data_y = densify_for_overlap(data_y);
    margin = 0.03;
    candidates = [
        pos(1) + (1 - inset_w - margin) * pos(3), pos(2) + (1 - inset_h - margin) * pos(4);
        pos(1) + margin * pos(3), pos(2) + (1 - inset_h - margin) * pos(4);
        pos(1) + (1 - inset_w - margin) * pos(3), pos(2) + margin * pos(4);
        pos(1) + margin * pos(3), pos(2) + margin * pos(4)];
    rects = [candidates, inset_w * pos(3) * ones(4, 1), inset_h * pos(4) * ones(4, 1)];

    x_lim = xlim(parent_ax);
    y_lim = ylim(parent_ax);
    x_norm = (data_x - x_lim(1)) / diff(x_lim);
    if strcmp(parent_ax.YScale, 'log')
        y_norm = (log10(data_y) - log10(y_lim(1))) / diff(log10(y_lim));
    else
        y_norm = (data_y - y_lim(1)) / diff(y_lim);
    end
    fig_x = pos(1) + x_norm * pos(3);
    fig_y = pos(2) + y_norm * pos(4);

    scores = zeros(4, 1);
    for idx = 1:4
        rect = rects(idx, :);
        inside = fig_x >= rect(1) & fig_x <= rect(1) + rect(3) & ...
            fig_y >= rect(2) & fig_y <= rect(2) + rect(4);
        scores(idx) = sum(inside);
    end
    scores = scores + legend_overlap_scores(parent_ax, rects);

    [~, best_idx] = min(scores);
    inset_pos = rects(best_idx, :);
end

function dense_values = densify_for_overlap(values)
    values = values(:);
    dense_values = values;
    if numel(values) < 2
        return;
    end
    extra = [];
    for idx = 1:numel(values)-1
        extra = [extra; linspace(values(idx), values(idx + 1), 8).']; %#ok<AGROW>
    end
    dense_values = [dense_values; extra];
end

function scores = legend_overlap_scores(parent_ax, rects)
    scores = zeros(size(rects, 1), 1);
    legends = findobj(ancestor(parent_ax, 'figure'), 'Type', 'Legend');
    for legend_idx = 1:numel(legends)
        legend_pos = legends(legend_idx).Position;
        for rect_idx = 1:size(rects, 1)
            if rectangles_overlap(rects(rect_idx, :), legend_pos)
                scores(rect_idx) = scores(rect_idx) + 100;
            end
        end
    end
end

function does_overlap = rectangles_overlap(a, b)
    does_overlap = a(1) < b(1) + b(3) && a(1) + a(3) > b(1) && ...
        a(2) < b(2) + b(4) && a(2) + a(4) > b(2);
end
