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
xlabel('SNR (dB)');
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
        'Color', [0, 0, 0], 'LineWidth', 1.9, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w'); hold on;
    semilogy(results.snr_db, results.bound, 'k:', ...
        'LineWidth', 1.8, 'Marker', 'x', 'MarkerSize', 8);
    semilogy(results.snr_db, results.mse_random, 's--', ...
        'Color', [0.35, 0.35, 0.35], 'LineWidth', 1.8, ...
        'MarkerSize', 7, 'MarkerFaceColor', 'w');
end

function add_training_mse_inset(parent_ax, results)
    pos = parent_ax.Position;
    inset_pos = [pos(1) + 0.56 * pos(3), pos(2) + 0.55 * pos(4), ...
        0.34 * pos(3), 0.34 * pos(4)];
    inset_ax = axes('Position', inset_pos);
    plot_training_mse_axes(inset_ax, results);
    xlim([max(results.snr_db) - 10, max(results.snr_db)]);
    high_snr_mask = results.snr_db >= max(results.snr_db) - 10;
    y_focus = [results.mse_czcp(high_snr_mask), results.bound(high_snr_mask)];
    ylim([0.85 * min(y_focus(:)), 1.25 * max(y_focus(:))]);
    grid on;
    set(gca, 'FontSize', 9, 'Box', 'on');
    xlabel('');
    ylabel('');
    title('Zoom', 'FontSize', 9);
    axes(parent_ax);
end
