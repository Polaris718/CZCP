clearvars;
if ~isappdata(0, 'KEEP_EXPERIMENT_FIGURES') || ~getappdata(0, 'KEEP_EXPERIMENT_FIGURES')
    close all;
end
clc;

% CZCP-SM 训练 MSE 基线对比。
%
% 1. 在 J = 2, 6, 18 且路径数为 5 时，比较每根发射天线 EbNo 与 MSE 的关系。
%    对比对象包括所提 CZCP 训练和随机稀疏训练。
%
% 2. 在 EbNo = 16 dB 且 E = 32 时，比较路径数与 MSE 的关系。
%    对比对象包括所提 CZCP 训练和多种基线种子序列。
%
% 说明：
% - Gold 序列采用标准确定性构造。
% - 训练矩阵维度遵循当前基线配置。
% - 所有曲线均使用 LS-MSE 表达式：
%   sigma2 * trace(inv(X' * X)) / num_params.

rng(7);

Nt = 4;
num_random_trials = 300;
ebno_db_grid = 0:2:20;
J_list = [2, 6, 18];
fixed_paths = 5;

% 参考表中的完美二元 (N = 8, Z = 4)-CZCP。
a8 = [1, 1, 1, -1, 1, 1, -1, 1];
b8 = [1, 1, 1, -1, -1, -1, 1, -1];

fprintf('Computing MSE versus EbNo...\n');
ebno_curves = compute_ebno_mse_curves(Nt, a8, b8, fixed_paths, J_list, ...
    ebno_db_grid, num_random_trials);

% 参考表中的完美二元 (N = 16, Z = 8)-CZCP。
a16 = [1, 1, 1, -1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1];
b16 = [1, 1, 1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, 1, 1, 1];

% 长度 16 的 GCP 基线。
gcp_a16 = [1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1];
gcp_b16 = [1, -1, 1, -1, 1, 1, -1, -1, 1, -1, -1, 1, 1, 1, 1, 1];

% 长度 31 的 m 序列基线。
mseq31 = [1, -1, -1, -1, -1, 1, -1, -1, 1, -1, 1, 1, -1, -1, 1, ...
    1, 1, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, 1, -1, 1, -1];

% 长度 13 的 Barker 基线，采用 4-by-104 稀疏结构，
% 此处直接实现该结构，而不调用论文公式。
barker13 = [1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];

% 由优选对生成的长度 31 Gold 序列。
gold31 = gold_sequence_31(9);

% 四条长度 32 的类 Zadoff-Chu 恒幅序列行。
zc32 = zeros(4, 32);
for row = 1:4
    zc32(row, :) = zadoff_chu_seq(row * 2 - 1, 32);
end

path_grid = 3:13;
fixed_ebno_db = 16;
fprintf('Computing MSE versus number of paths...\n');
path_curves = compute_path_mse_curves(Nt, a16, b16, gcp_a16, gcp_b16, mseq31, ...
    barker13, gold31, zc32, path_grid, fixed_ebno_db, num_random_trials);

save('mse_comparison_results.mat', 'ebno_curves', 'path_curves');

figure('Color', 'w', 'Position', [80, 80, 1450, 650]);
tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

ax_ebno = nexttile;
plot_ebno_curves(ax_ebno, ebno_db_grid, ebno_curves, J_list);
grid on;
xlabel('EbNo per TA (dB)');
ylabel('MSE (dB)');
title('(a) No. of multi-paths = 5');
legend('CZCP J=2', 'Random J=2', 'Min J=2', ...
    'CZCP J=6', 'Random J=6', 'Min J=6', ...
    'CZCP J=18', 'Random J=18', 'Min J=18', ...
    'Location', 'southwest');
add_ebno_inset(ax_ebno, ebno_db_grid, ebno_curves, J_list);

ax_paths = nexttile;
plot_path_curves(ax_paths, path_grid, path_curves);
grid on;
xlabel('Number of multi-paths');
ylabel('MSE (dB)');
title('(b) EbNo = 16 dB, E = 32');
legend('CZCP', 'GCP', 'm-sequence', 'Barker', 'Gold', ...
    'Zadoff-Chu', 'Random', 'Minimum MSE', 'Location', 'northwest');
add_path_inset(ax_paths, path_grid, path_curves);

saveas(gcf, 'mse_comparison_both.png');

figure('Color', 'w', 'Position', [100, 100, 1050, 720]);
ax_ebno_single = axes;
plot_ebno_curves(ax_ebno_single, ebno_db_grid, ebno_curves, J_list);
grid on;
xlabel('EbNo per TA (dB)');
ylabel('MSE (dB)');
title('MSE versus EbNo');
legend('CZCP J=2', 'Random J=2', 'Min J=2', ...
    'CZCP J=6', 'Random J=6', 'Min J=6', ...
    'CZCP J=18', 'Random J=18', 'Min J=18', ...
    'Location', 'southwest');
add_ebno_inset(ax_ebno_single, ebno_db_grid, ebno_curves, J_list);
saveas(gcf, 'mse_vs_ebno.png');

figure('Color', 'w', 'Position', [100, 100, 1050, 720]);
ax_paths_single = axes;
plot_path_curves(ax_paths_single, path_grid, path_curves);
grid on;
xlabel('Number of multi-paths');
ylabel('MSE (dB)');
title('MSE versus Number of Paths');
legend('CZCP', 'GCP', 'm-sequence', 'Barker', 'Gold', ...
    'Zadoff-Chu', 'Random', 'Minimum MSE', 'Location', 'northwest');
add_path_inset(ax_paths_single, path_grid, path_curves);
saveas(gcf, 'mse_vs_paths.png');

fprintf('Saved:\n');
fprintf('  mse_comparison_results.mat\n');
fprintf('  mse_comparison_both.png\n');
fprintf('  mse_vs_ebno.png\n');
fprintf('  mse_vs_paths.png\n');

function plot_ebno_curves(ax, ebno_db_grid, ebno_curves, J_list)
    axes(ax);
    for j_idx = 1:length(J_list)
        [line_style, marker, color, line_width] = ebno_curve_style(j_idx, 'czcp');
        plot(ebno_db_grid, ebno_curves.proposed_db(j_idx, :), line_style, ...
            'Color', color, 'LineWidth', line_width, 'Marker', marker, ...
            'MarkerSize', 6.5, 'MarkerFaceColor', 'w'); hold on;

        [line_style, marker, color, line_width] = ebno_curve_style(j_idx, 'random');
        plot(ebno_db_grid, ebno_curves.random_db(j_idx, :), line_style, ...
            'Color', color, 'LineWidth', line_width, 'Marker', marker, ...
            'MarkerSize', 6.5, 'MarkerFaceColor', 'w');

        [line_style, marker, color, line_width] = ebno_curve_style(j_idx, 'bound');
        plot(ebno_db_grid, ebno_curves.bound_db(j_idx, :), line_style, ...
            'Color', color, 'LineWidth', line_width, 'Marker', marker, ...
            'MarkerSize', 7);
    end
end

function plot_path_curves(ax, path_grid, path_curves)
    axes(ax);
    plot(path_grid, path_curves.proposed_db, 'o-', ...
        'Color', [0.0000, 0.4470, 0.7410], 'LineWidth', 1.9, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w'); hold on;
    plot(path_grid, path_curves.gcp_db, 's-', ...
        'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.6, ...
        'MarkerSize', 6.5, 'MarkerFaceColor', 'w');
    plot(path_grid, path_curves.mseq_db, '^-', ...
        'Color', [0.9290, 0.6940, 0.1250], 'LineWidth', 1.6, ...
        'MarkerSize', 6.5, 'MarkerFaceColor', 'w');
    plot(path_grid, path_curves.barker_db, 'd-.', ...
        'Color', [0.4940, 0.1840, 0.5560], 'LineWidth', 1.6, ...
        'MarkerSize', 6.5, 'MarkerFaceColor', 'w');
    plot(path_grid, path_curves.gold_db, 'v--', ...
        'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 1.6, ...
        'MarkerSize', 6.5, 'MarkerFaceColor', 'w');
    plot(path_grid, path_curves.zc_db, 'x:', ...
        'Color', [0.3010, 0.7450, 0.9330], 'LineWidth', 1.8, ...
        'MarkerSize', 7);
    plot(path_grid, path_curves.random_db, '>--', ...
        'Color', [0.6350, 0.0780, 0.1840], 'LineWidth', 1.6, ...
        'MarkerSize', 6.5, 'MarkerFaceColor', 'w');
    plot(path_grid, path_curves.bound_db, '+:', ...
        'Color', [0.2500, 0.2500, 0.2500], 'LineWidth', 1.7, ...
        'MarkerSize', 7);
end

function [line_style, marker, color, line_width] = ebno_curve_style(j_idx, curve_type)
    colors = [0.0000, 0.4470, 0.7410; ...
              0.8500, 0.3250, 0.0980; ...
              0.4940, 0.1840, 0.5560];
    switch curve_type
        case 'czcp'
            markers = {'o', 's', '^'};
            line_style = '-';
            marker = markers{j_idx};
            color = colors(j_idx, :);
            line_width = 1.9;
        case 'random'
            markers = {'d', 'v', '>'};
            line_style = '--';
            marker = markers{j_idx};
            color = colors(j_idx, :);
            line_width = 1.7;
        otherwise
            markers = {'x', '+', '*'};
            line_style = ':';
            marker = markers{j_idx};
            color = colors(j_idx, :);
            line_width = 1.7;
    end
end

function add_ebno_inset(parent_ax, ebno_db_grid, ebno_curves, J_list)
    pos = parent_ax.Position;
    inset_pos = [pos(1) + 0.58 * pos(3), pos(2) + 0.54 * pos(4), ...
        0.34 * pos(3), 0.34 * pos(4)];
    inset_ax = axes('Position', inset_pos);
    plot_ebno_curves(inset_ax, ebno_db_grid, ebno_curves, J_list);
    zoom_mask = ebno_db_grid >= max(ebno_db_grid) - 6;
    y_focus = [ebno_curves.proposed_db(:, zoom_mask); ebno_curves.bound_db(:, zoom_mask)];
    xlim([max(ebno_db_grid) - 6, max(ebno_db_grid)]);
    y_span = max(y_focus(:)) - min(y_focus(:));
    y_pad = max(0.08 * y_span, 0.08);
    ylim([min(y_focus(:)) - y_pad, max(y_focus(:)) + y_pad]);
    grid on;
    set(gca, 'FontSize', 9, 'Box', 'on');
    xlabel('');
    ylabel('');
    title('Zoom', 'FontSize', 9);
    uistack(inset_ax, 'top');
end

function add_path_inset(parent_ax, path_grid, path_curves)
    pos = parent_ax.Position;
    inset_pos = [pos(1) + 0.58 * pos(3), pos(2) + 0.54 * pos(4), ...
        0.34 * pos(3), 0.34 * pos(4)];
    inset_ax = axes('Position', inset_pos);
    plot_path_curves(inset_ax, path_grid, path_curves);
    zoom_mask = path_grid <= min(path_grid) + 4;
    y_focus = [path_curves.proposed_db(zoom_mask); path_curves.bound_db(zoom_mask)];
    xlim([min(path_grid), min(path_grid) + 4]);
    y_span = max(y_focus(:)) - min(y_focus(:));
    y_pad = max(0.12 * y_span, 0.08);
    ylim([min(y_focus(:)) - y_pad, max(y_focus(:)) + y_pad]);
    grid on;
    set(gca, 'FontSize', 9, 'Box', 'on');
    xlabel('');
    ylabel('');
    title('Zoom', 'FontSize', 9);
    uistack(inset_ax, 'top');
end

function ebno_curves = compute_ebno_mse_curves(Nt, a, b, paths, J_list, ebno_db, random_trials)
    theta = length(a);
    channel_len = paths;
    ebno_curves.proposed_db = zeros(length(J_list), length(ebno_db));
    ebno_curves.random_db = zeros(length(J_list), length(ebno_db));
    ebno_curves.bound_db = zeros(length(J_list), length(ebno_db));

    for j_idx = 1:length(J_list)
        J = J_list(j_idx);
        Omega_proposed = build_czcp_sm_training(a, b, Nt, J, 1);
        E = sum(abs(Omega_proposed(1, :)).^2);

        proposed_trace = mse_trace_factor(Omega_proposed, channel_len);
        random_trace = 0;
        for trial = 1:random_trials
            Omega_random = build_binary_random_regular_training(Nt, theta, J);
            random_trace = random_trace + mse_trace_factor(Omega_random, channel_len);
        end
        random_trace = random_trace / random_trials;

        for snr_idx = 1:length(ebno_db)
            noise_var = 10^(-ebno_db(snr_idx) / 10);
            ebno_curves.proposed_db(j_idx, snr_idx) = 10 * log10(noise_var * proposed_trace);
            ebno_curves.random_db(j_idx, snr_idx) = 10 * log10(noise_var * random_trace);
            ebno_curves.bound_db(j_idx, snr_idx) = 10 * log10(noise_var / E);
        end
    end
end

function path_curves = compute_path_mse_curves(Nt, czcp_a, czcp_b, gcp_a, gcp_b, mseq, ...
    barker, gold, zc_rows, paths_list, ebno_db, random_trials)

    noise_var = 10^(-ebno_db / 10);
    E_target = 32;
    J = 2;

    Omega_czcp = normalize_training_energy( ...
        build_czcp_sm_training(czcp_a, czcp_b, Nt, J, 1), E_target);
    Omega_gcp = normalize_training_energy( ...
        build_czcp_sm_training(gcp_a, gcp_b, Nt, J, 1), E_target);
    Omega_mseq = normalize_training_energy( ...
        build_structure48_from_rows(repmat(mseq, Nt, 1)), E_target);
    Omega_barker = normalize_training_energy( ...
        build_barker104_training(barker, Nt), E_target);
    Omega_gold = normalize_training_energy( ...
        build_structure48_from_rows(repmat(gold, Nt, 1)), E_target);
    Omega_zc = normalize_training_energy( ...
        build_structure48_from_rows(zc_rows), E_target);

    path_curves.proposed_db = zeros(size(paths_list));
    path_curves.gcp_db = zeros(size(paths_list));
    path_curves.mseq_db = zeros(size(paths_list));
    path_curves.barker_db = zeros(size(paths_list));
    path_curves.gold_db = zeros(size(paths_list));
    path_curves.zc_db = zeros(size(paths_list));
    path_curves.random_db = zeros(size(paths_list));
    path_curves.bound_db = zeros(size(paths_list));
    path_curves.notes = ['Gold uses a standard length-31 preferred-pair ' ...
        'construction. CAN is omitted because official CAN coefficients ' ...
        'were not available.'];

    for idx = 1:length(paths_list)
        channel_len = paths_list(idx);
        path_curves.proposed_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_czcp, channel_len));
        path_curves.gcp_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_gcp, channel_len));
        path_curves.mseq_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_mseq, channel_len));
        path_curves.barker_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_barker, channel_len));
        path_curves.gold_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_gold, channel_len));
        path_curves.zc_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_zc, channel_len));
        path_curves.bound_db(idx) = 10 * log10(noise_var / E_target);

        random_trace = 0;
        for trial = 1:random_trials
            Omega_random = normalize_training_energy( ...
                build_structure48_from_rows(2 * randi([0, 1], Nt, 32) - 1), E_target);
            random_trace = random_trace + mse_trace_factor(Omega_random, channel_len);
        end
        path_curves.random_db(idx) = 10 * log10(noise_var * random_trace / random_trials);
    end
end

function trace_factor = mse_trace_factor(Omega, channel_len)
    X = build_training_matrix(Omega, channel_len);
    Gram = X' * X;
    num_params = size(Gram, 1);
    if rank(Gram, 1e-10) < num_params
        trace_factor = Inf;
    else
        trace_factor = real(trace(inv(Gram)) / num_params);
    end
end

function Omega = build_binary_random_regular_training(Nt, theta, J)
    base_len = 2 * Nt * theta;
    Omega_e = zeros(Nt, base_len);
    for block = 1:(2 * Nt)
        active_row = mod(block - 1, Nt) + 1;
        cols = (block - 1) * theta + (1:theta);
        Omega_e(active_row, cols) = 2 * randi([0, 1], 1, theta) - 1;
    end
    Omega = repmat(Omega_e, 1, J / 2);
end

function Omega = build_structure48_from_rows(rows)
    [Nt, theta] = size(rows);
    Omega = zeros(Nt, Nt * theta);
    for nt = 1:Nt
        cols = (nt - 1) * theta + (1:theta);
        Omega(nt, cols) = rows(nt, :);
    end
end

function Omega = build_barker104_training(barker, Nt)
    theta = length(barker);
    Omega = zeros(Nt, 2 * Nt * theta);
    for nt = 1:Nt
        first_cols = (nt - 1) * theta + (1:theta);
        second_cols = (Nt + nt - 1) * theta + (1:theta);
        Omega(nt, first_cols) = barker;
        Omega(nt, second_cols) = barker;
    end
end

function Omega = normalize_training_energy(Omega, E_target)
    row_energy = sum(abs(Omega(1, :)).^2);
    Omega = Omega * sqrt(E_target / row_energy);
end

function z = zadoff_chu_seq(root, N)
    n = 0:N-1;
    if mod(N, 2) == 0
        z = exp(-1i * pi * root * n.^2 / N);
    else
        z = exp(-1i * pi * root * n .* (n + 1) / N);
    end
end

function seq = gold_sequence_31(shift)
    s1 = m_sequence_binary([5, 2], 5);
    s2 = m_sequence_binary([5, 4, 3, 2], 5);
    gold_bits = xor(s1, circshift(s2, [0, shift]));
    seq = 1 - 2 * gold_bits;
end

function bits = m_sequence_binary(taps, m)
    state = ones(1, m);
    bits = zeros(1, 2^m - 1);
    for idx = 1:length(bits)
        bits(idx) = state(end);
        feedback = mod(sum(state(m - taps + 1)), 2);
        state = [feedback, state(1:end-1)];
    end
end
