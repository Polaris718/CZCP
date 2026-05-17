clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

% Plot comparison figures for the CZCP-SM training experiment.
% Run run_training_mse_experiment first, or let this script run it automatically.

result_file = 'training_mse_experiment_results.mat';

if ~isfile(result_file)
    fprintf('Result file not found. Running run_training_mse_experiment...\n');
    run_training_mse_experiment;
end

if ~exist('result_file', 'var')
    result_file = 'training_mse_experiment_results.mat';
end

load(result_file, 'results');

figure('Color', 'w');
semilogy(results.snr_db, results.mse_czcp, 'o-', ...
    'LineWidth', 1.8, 'MarkerSize', 7); hold on;
semilogy(results.snr_db, results.bound, 'k--', ...
    'LineWidth', 1.6);
semilogy(results.snr_db, results.mse_random, 's-', ...
    'LineWidth', 1.8, 'MarkerSize', 7);
grid on;
xlabel('SNR (dB)');
ylabel('Normalized MSE');
legend('CZCP training', 'Theoretical lower bound', ...
    'Random same-support training', 'Location', 'southwest');
title('Training MSE Comparison');
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
