clearvars;
if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES')
    close all;
end
clc;

% 第 IV 节 CZCP-SM 训练实验的 Monte Carlo 验证。
% 理论 LS-MSE 曲线由 X'X 计算；经验曲线通过随机信道
% 多次试验估计，并与 LS 信道估计结果对比。

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

figure('Color', 'w', 'Position', [100, 100, 1050, 720]);
ax = axes;
plot_monte_carlo_axes(ax, snr_db, results);
grid on;
xlabel('SNR (dB)');
ylabel('Normalized MSE');
legend('CZCP theory', 'CZCP Monte Carlo', 'Lower bound', ...
    'Random theory', 'Random Monte Carlo', 'Location', 'southwest');
title('Monte Carlo LS Channel Estimation Verification');
add_monte_carlo_inset(ax, snr_db, results);
saveas(gcf, 'monte_carlo_channel_mse.png');

fprintf('Saved:\n');
fprintf('  monte_carlo_channel_results.mat\n');
fprintf('  monte_carlo_channel_mse.png\n');

function plot_monte_carlo_axes(ax, snr_db, results)
    axes(ax);
    semilogy(snr_db, results.theory_czcp, 'o-', ...
        'Color', [0.0000, 0.4470, 0.7410], 'LineWidth', 1.9, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w'); hold on;
    semilogy(snr_db, results.empirical_czcp, 'o--', ...
        'Color', [0.0000, 0.4470, 0.7410], 'LineWidth', 1.8, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w');
    semilogy(snr_db, results.bound, 'x:', ...
        'Color', [0.2500, 0.2500, 0.2500], 'LineWidth', 1.7, ...
        'MarkerSize', 8);
    semilogy(snr_db, results.theory_random, 's-', ...
        'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.8, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w');
    semilogy(snr_db, results.empirical_random, 's--', ...
        'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.8, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w');
    set(ax, 'FontSize', 14, 'LineWidth', 1.1);
end

function add_monte_carlo_inset(parent_ax, snr_db, results)
    data_x = repmat(snr_db(:), 5, 1);
    data_y = [results.theory_czcp(:); results.empirical_czcp(:); results.bound(:); ...
        results.theory_random(:); results.empirical_random(:)];
    inset_pos = choose_inset_position(parent_ax, data_x, data_y, 0.34, 0.34);
    inset_ax = axes('Position', inset_pos);
    plot_monte_carlo_axes(inset_ax, snr_db, results);

    high_snr_mask = snr_db >= max(snr_db) - 10;
    y_focus = [results.theory_czcp(high_snr_mask), results.empirical_czcp(high_snr_mask), ...
        results.bound(high_snr_mask)];
    zoom_xlim = [max(snr_db) - 10, max(snr_db)];
    xlim(zoom_xlim);
    y_min = min(y_focus(:));
    y_max = max(y_focus(:));
    zoom_ylim = [max(y_min / 1.35, eps), y_max * 1.35];
    ylim(zoom_ylim);
    grid on;
    set(gca, 'FontSize', 11, 'Box', 'on', 'LineWidth', 1.0);
    xlabel('');
    ylabel('');
    title('Zoom', 'FontSize', 12);
    uistack(inset_ax, 'top');
    add_zoom_arrow(parent_ax, inset_ax, zoom_xlim, zoom_ylim);
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

function add_zoom_arrow(parent_ax, inset_ax, zoom_xlim, zoom_ylim)
    fig = ancestor(parent_ax, 'figure');
    y_mid = mean(zoom_ylim);
    if strcmp(parent_ax.YScale, 'log')
        y_mid = 10^mean(log10(zoom_ylim));
    end
    start = data_to_figure_coords(parent_ax, mean(zoom_xlim), y_mid);
    inset_pos = inset_ax.Position;
    inset_center = [inset_pos(1) + inset_pos(3) / 2, inset_pos(2) + inset_pos(4) / 2];
    end_pt = nearest_rect_edge(inset_pos, start, inset_center);
    annotation(fig, 'arrow', [start(1), end_pt(1)], [start(2), end_pt(2)], ...
        'Color', [0.15, 0.15, 0.15], 'LineWidth', 1.2, 'HeadLength', 8, 'HeadWidth', 8);
end

function pt = data_to_figure_coords(ax, x, y)
    ax_pos = ax.Position;
    x_lim = xlim(ax);
    y_lim = ylim(ax);
    x_norm = (x - x_lim(1)) / diff(x_lim);
    if strcmp(ax.YScale, 'log')
        y_norm = (log10(y) - log10(y_lim(1))) / diff(log10(y_lim));
    else
        y_norm = (y - y_lim(1)) / diff(y_lim);
    end
    pt = [ax_pos(1) + x_norm * ax_pos(3), ax_pos(2) + y_norm * ax_pos(4)];
end

function pt = nearest_rect_edge(rect, start, center)
    direction = center - start;
    if all(abs(direction) < eps)
        pt = center;
        return;
    end
    scales = [];
    if direction(1) > 0
        scales(end + 1) = (rect(1) - start(1)) / direction(1); %#ok<AGROW>
    elseif direction(1) < 0
        scales(end + 1) = (rect(1) + rect(3) - start(1)) / direction(1); %#ok<AGROW>
    end
    if direction(2) > 0
        scales(end + 1) = (rect(2) - start(2)) / direction(2); %#ok<AGROW>
    elseif direction(2) < 0
        scales(end + 1) = (rect(2) + rect(4) - start(2)) / direction(2); %#ok<AGROW>
    end
    scales = scales(scales > 0);
    if isempty(scales)
        pt = center;
        return;
    end
    scale = min(scales);
    pt = start + scale * direction;
end

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
