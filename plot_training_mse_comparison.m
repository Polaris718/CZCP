clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

% CZCP-SM 实验脚本。

result_file = 'training_mse_experiment_results.mat';

if ~isfile(result_file)
    fprintf('Result file not found. Running run_training_mse_experiment...\n');
    run_training_mse_experiment;
end

if ~exist('result_file', 'var')
    result_file = 'training_mse_experiment_results.mat';
end

load(result_file, 'results');

figure('Color', 'w', 'Position', [100, 100, 1050, 720]);
ax = axes;
plot_training_mse_axes(ax, results);
grid on;
xlabel('EbNo per TA (dB)');
ylabel('Normalized MSE');
legend('CZCP training', 'Theoretical lower bound', ...
    'Random same-support training', 'Location', 'southwest');
title('Training MSE Comparison');
add_training_mse_inset(ax, results);
saveas(gcf, 'training_mse_comparison.png');

figure('Color', 'w');
bar([results.gram_err_czcp, results.gram_err_random]);
set(gca, 'XTickLabel', {'CZCP', 'Random'});
set(gca, 'YScale', 'log');
grid on;
ylabel('max |X^H X - E I|');
title('Training Matrix Orthogonality Error');
saveas(gcf, 'training_gram_error_comparison.png');

fprintf('Figures saved:\n');
fprintf('  training_mse_comparison.png\n');
fprintf('  training_gram_error_comparison.png\n');

function plot_training_mse_axes(ax, results)
    axes(ax);
    semilogy(results.snr_db, results.mse_czcp, 'o-', ...
        'Color', [0.0000, 0.4470, 0.7410], 'LineWidth', 1.9, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w'); hold on;
    semilogy(results.snr_db, results.bound, 'x:', ...
        'Color', [0.8500, 0.3250, 0.0980], 'LineWidth', 1.8, ...
        'MarkerSize', 8);
    semilogy(results.snr_db, results.mse_random, 's--', ...
        'Color', [0.4660, 0.6740, 0.1880], 'LineWidth', 1.8, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w');
    set(ax, 'FontSize', 14, 'LineWidth', 1.1);
end

function add_training_mse_inset(parent_ax, results)
    data_x = repmat(results.snr_db(:), 3, 1);
    data_y = [results.mse_czcp(:); results.bound(:); results.mse_random(:)];
    inset_pos = choose_inset_position(parent_ax, data_x, data_y, 0.34, 0.34);
    inset_ax = axes('Position', inset_pos);
    plot_training_mse_axes(inset_ax, results);
    high_snr_mask = results.snr_db >= max(results.snr_db) - 5;
    y_focus = [results.mse_czcp(high_snr_mask), results.bound(high_snr_mask)];
    zoom_xlim = [max(results.snr_db) - 5, max(results.snr_db)];
    xlim(zoom_xlim);
    y_min = min(y_focus(:));
    y_max = max(y_focus(:));
    zoom_ylim = [max(y_min / 1.25, eps), y_max * 1.25];
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
