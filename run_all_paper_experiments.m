function run_all_paper_experiments
close all; clc;
setappdata(0, 'KEEP_PAPER_FIGURES', true);

% One-click runner for the CZCP-SM paper reproduction project.
% It executes the core verification and experiment scripts, then checks the
% expected output artifacts.

diary_file = 'paper_experiment_run_log.txt';
if isfile(diary_file)
    delete(diary_file);
end
diary(diary_file);
cleanup = onCleanup(@() cleanup_runner_state());

fprintf('CZCP-SM paper experiment run\n');
fprintf('Started: %s\n\n', char(datetime('now')));

scripts = { ...
    'example6', ...
    'definite6', ...
    'main_section4_experiment', ...
    'plot_section4_comparison', ...
    'reproduce_fig6', ...
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
    'section4_experiment_results.mat', ...
    '第4节_MSE性能对比.png', ...
    '第4节_Gram正交性误差对比.png', ...
    'fig6_reproduction_results.mat', ...
    '图6_复现总览.png', ...
    '图6a_MSE随EbNo变化.png', ...
    '图6b_MSE随多径数变化.png', ...
    'monte_carlo_channel_results.mat', ...
    '蒙特卡洛_信道估计MSE验证.png' ...
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
    title(strrep(file_name, '_', '\_'));
    drawnow;
    fprintf('DISPLAY: %s\n', file_name);
end
end

function cleanup_runner_state()
diary('off');
if isappdata(0, 'KEEP_PAPER_FIGURES')
    rmappdata(0, 'KEEP_PAPER_FIGURES');
end
end
