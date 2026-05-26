function run_all_experiments
close all; clc;
setappdata(0, 'KEEP_EXPERIMENT_FIGURES', true);

% CZCP-SM璁烘枃澶嶇幇瀹為獙鐨勪竴閿繍琛屽叆鍙ｃ€?% 渚濇鎵ц鏍稿績楠岃瘉涓庡疄楠岃剼鏈紝骞舵鏌ラ鏈熻緭鍑轰骇鐗┿€?
diary_file = 'experiment_run_log.txt';
if isfile(diary_file)
    delete(diary_file);
end
diary(diary_file);
cleanup = onCleanup(@() cleanup_runner_state());

fprintf('CZCP-SM experiment run\n');
fprintf('Started: %s\n\n', char(datetime('now')));

scripts = { ...
    'verify_golay_definition', ...
    'verify_gbf_definition', ...
    'verify_czcp_conditions', ...
    'verify_czcs_construction', ...
    'run_training_mse_experiment', ...
    'plot_training_mse_comparison', ...
    'plot_training_mse_baselines', ...
    'monte_carlo_channel_simulation' ...
};

for idx = 1:numel(scripts)
    script_name = scripts{idx};
    fprintf('\n=== Running %s ===\n', script_name);
    try
        evalin('base', script_name);
        fprintf('PASS: %s\n', script_name);
    catch err
        fprintf('FAIL: %s\n', script_name);
        fprintf('%s\n', getReport(err, 'extended', 'hyperlinks', 'off'));
        rethrow(err);
    end
end

expected_files = { ...
    'golay_definition_results.mat', ...
    'gbf_definition_results.mat', ...
    'training_mse_experiment_results.mat', ...
    'training_mse_experiment.png', ...
    'training_mse_comparison.png', ...
    'training_gram_error_comparison.png', ...
    'mse_comparison_results.mat', ...
    'mse_comparison_both.png', ...
    'mse_vs_ebno.png', ...
    'mse_vs_paths.png', ...
    'monte_carlo_channel_results.mat', ...
    'monte_carlo_channel_mse.png' ...
};

fprintf('\n=== Output artifact check ===\n');
missing_files = {};
for idx = 1:numel(expected_files)
    file_name = expected_files{idx};
    if isfile(file_name)
        info = dir(file_name);
        fprintf('OK: %s (%d bytes)\n', file_name, info.bytes);
    else
        fprintf('MISSING: %s\n', file_name);
        missing_files{end + 1} = file_name; %#ok<SAGROW>
    end
end

if ~isempty(missing_files)
    error('Some expected output artifacts were not generated.');
end

display_output_pngs(expected_files);

fprintf('\nAll experiments completed successfully.\n');
fprintf('Finished: %s\n', char(datetime('now')));
end

function display_output_pngs(expected_files)
png_files = expected_files(endsWith(expected_files, '.png'));

fprintf('\n=== Displaying output figures ===\n');
for idx = 1:numel(png_files)
    file_name = png_files{idx};
    if ~isfile(file_name)
        continue;
    end

    img = imread(file_name);
    figure('Color', 'w', 'Name', file_name, 'NumberTitle', 'off');
    image(img);
    axis image off;
    title(display_title_for_png(file_name));
    drawnow;
    fprintf('DISPLAY: %s\n', file_name);
end
end

function display_title = display_title_for_png(file_name)
switch file_name
    case 'mse_vs_ebno.png'
        display_title = 'MSE versus EbNo';
    case 'mse_vs_paths.png'
        display_title = 'MSE versus Number of Paths';
    otherwise
        display_title = strrep(file_name, '_', '\_');
end
end

function cleanup_runner_state()
diary('off');
if isappdata(0, 'KEEP_EXPERIMENT_FIGURES')
    rmappdata(0, 'KEEP_EXPERIMENT_FIGURES');
end
end

