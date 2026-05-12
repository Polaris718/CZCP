clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

% Reproduce Fig. 6 style comparisons from the CZCP-SM training paper.
%
% Fig. 6(a): MSE versus EbNo per transmit antenna, path number = 5,
%            J in {2, 6, 18}, proposed CZCP versus random sparse training.
% Fig. 6(b): MSE versus number of paths at EbNo = 16 dB and E = 32,
%            proposed CZCP versus several seed-sequence baselines.
%
% Notes:
% - No official Fig. 6 MATLAB code was found locally. Gold is reproduced
%   from a standard deterministic construction, while the training matrix
%   dimensions follow the paper description.
% - All curves are computed from the LS-MSE expression
%   sigma2 * trace(inv(X' * X)) / num_params.

rng(7);

Nt = 4;
num_random_trials = 300;
fig6a_ebno_db = 0:2:20;
fig6a_J_list = [2, 6, 18];
fig6a_paths = 5;

% Table I perfect binary (N=8,Z=4)-CZCP.
a8 = [1, 1, 1, -1, 1, 1, -1, 1];
b8 = [1, 1, 1, -1, -1, -1, 1, -1];

fprintf('Computing Fig. 6(a)...\n');
fig6a = compute_fig6a(Nt, a8, b8, fig6a_paths, fig6a_J_list, ...
    fig6a_ebno_db, num_random_trials);

% Table I perfect binary (N=16,Z=8)-CZCP.
a16 = [1, 1, 1, -1, 1, 1, -1, 1, 1, -1, 1, 1, 1, -1, -1, -1];
b16 = [1, 1, 1, -1, 1, 1, -1, 1, -1, 1, -1, -1, -1, 1, 1, 1];

% Length-16 GCP from the paper text.
gcp_a16 = [1, 1, 1, 1, 1, -1, -1, 1, 1, 1, -1, -1, 1, -1, 1, -1];
gcp_b16 = [1, -1, 1, -1, 1, 1, -1, -1, 1, -1, -1, 1, 1, 1, 1, 1];

% Length-31 m-sequence from the paper text.
mseq31 = [1, -1, -1, -1, -1, 1, -1, -1, 1, -1, 1, 1, -1, -1, 1, ...
    1, 1, 1, 1, -1, -1, -1, 1, 1, -1, 1, 1, 1, -1, 1, -1];

% Length-13 Barker sequence from the paper text. The paper uses a 4-by-104
% sparse structure for Barker, implemented below instead of formula (48).
barker13 = [1, 1, 1, 1, 1, -1, -1, 1, 1, -1, 1, -1, 1];

% Length-31 Gold sequence from a preferred m-sequence pair.
gold31 = gold_sequence_31(9);

% Four length-32 Zadoff-Chu style constant-amplitude sequences.
zc32 = zeros(4, 32);
for row = 1:4
    zc32(row, :) = zadoff_chu_seq(row * 2 - 1, 32);
end

fig6b_paths = 3:13;
fig6b_ebno_db = 16;
fprintf('Computing Fig. 6(b)...\n');
fig6b = compute_fig6b(Nt, a16, b16, gcp_a16, gcp_b16, mseq31, ...
    barker13, gold31, zc32, fig6b_paths, fig6b_ebno_db, num_random_trials);

save('fig6_reproduction_results.mat', 'fig6a', 'fig6b');

figure('Color', 'w', 'Position', [100, 100, 1100, 450]);
tiledlayout(1, 2, 'TileSpacing', 'compact', 'Padding', 'compact');

nexttile;
colors = lines(length(fig6a_J_list));
for j_idx = 1:length(fig6a_J_list)
    plot(fig6a_ebno_db, fig6a.proposed_db(j_idx, :), '-', ...
        'Color', colors(j_idx, :), 'LineWidth', 1.7); hold on;
    plot(fig6a_ebno_db, fig6a.random_db(j_idx, :), '--', ...
        'Color', colors(j_idx, :), 'LineWidth', 1.5);
    plot(fig6a_ebno_db, fig6a.bound_db(j_idx, :), ':', ...
        'Color', colors(j_idx, :), 'LineWidth', 1.4);
end
grid on;
xlabel('EbNo per TA (dB)');
ylabel('MSE (dB)');
title('(a) No. of multi-paths = 5');
legend('CZCP J=2', 'Random J=2', 'Min J=2', ...
    'CZCP J=6', 'Random J=6', 'Min J=6', ...
    'CZCP J=18', 'Random J=18', 'Min J=18', ...
    'Location', 'southwest');

nexttile;
plot(fig6b_paths, fig6b.proposed_db, 'o-', 'LineWidth', 1.8); hold on;
plot(fig6b_paths, fig6b.gcp_db, 's-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.mseq_db, '^-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.barker_db, 'd-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.gold_db, 'v-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.zc_db, 'x-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.random_db, '--', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.bound_db, 'k:', 'LineWidth', 1.4);
grid on;
xlabel('Number of multi-paths');
ylabel('MSE (dB)');
title('(b) EbNo = 16 dB, E = 32');
legend('CZCP', 'GCP', 'm-sequence', 'Barker', 'Gold', ...
    'Zadoff-Chu', 'Random', 'Minimum MSE', 'Location', 'northwest');

saveas(gcf, 'fig6_reproduction_both.png');

figure('Color', 'w');
for j_idx = 1:length(fig6a_J_list)
    plot(fig6a_ebno_db, fig6a.proposed_db(j_idx, :), '-', ...
        'Color', colors(j_idx, :), 'LineWidth', 1.7); hold on;
    plot(fig6a_ebno_db, fig6a.random_db(j_idx, :), '--', ...
        'Color', colors(j_idx, :), 'LineWidth', 1.5);
    plot(fig6a_ebno_db, fig6a.bound_db(j_idx, :), ':', ...
        'Color', colors(j_idx, :), 'LineWidth', 1.4);
end
grid on;
xlabel('EbNo per TA (dB)');
ylabel('MSE (dB)');
title('Fig. 6(a) Reproduction');
legend('CZCP J=2', 'Random J=2', 'Min J=2', ...
    'CZCP J=6', 'Random J=6', 'Min J=6', ...
    'CZCP J=18', 'Random J=18', 'Min J=18', ...
    'Location', 'southwest');
saveas(gcf, 'fig6a_reproduction.png');

figure('Color', 'w');
plot(fig6b_paths, fig6b.proposed_db, 'o-', 'LineWidth', 1.8); hold on;
plot(fig6b_paths, fig6b.gcp_db, 's-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.mseq_db, '^-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.barker_db, 'd-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.gold_db, 'v-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.zc_db, 'x-', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.random_db, '--', 'LineWidth', 1.5);
plot(fig6b_paths, fig6b.bound_db, 'k:', 'LineWidth', 1.4);
grid on;
xlabel('Number of multi-paths');
ylabel('MSE (dB)');
title('Fig. 6(b) Reproduction');
legend('CZCP', 'GCP', 'm-sequence', 'Barker', 'Gold', ...
    'Zadoff-Chu', 'Random', 'Minimum MSE', 'Location', 'northwest');
saveas(gcf, 'fig6b_reproduction.png');

fprintf('Saved:\n');
fprintf('  fig6_reproduction_results.mat\n');
fprintf('  fig6_reproduction_both.png\n');
fprintf('  fig6a_reproduction.png\n');
fprintf('  fig6b_reproduction.png\n');

function fig6a = compute_fig6a(Nt, a, b, paths, J_list, ebno_db, random_trials)
    theta = length(a);
    channel_len = paths;
    fig6a.proposed_db = zeros(length(J_list), length(ebno_db));
    fig6a.random_db = zeros(length(J_list), length(ebno_db));
    fig6a.bound_db = zeros(length(J_list), length(ebno_db));

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
            fig6a.proposed_db(j_idx, snr_idx) = 10 * log10(noise_var * proposed_trace);
            fig6a.random_db(j_idx, snr_idx) = 10 * log10(noise_var * random_trace);
            fig6a.bound_db(j_idx, snr_idx) = 10 * log10(noise_var / E);
        end
    end
end

function fig6b = compute_fig6b(Nt, czcp_a, czcp_b, gcp_a, gcp_b, mseq, ...
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

    fig6b.proposed_db = zeros(size(paths_list));
    fig6b.gcp_db = zeros(size(paths_list));
    fig6b.mseq_db = zeros(size(paths_list));
    fig6b.barker_db = zeros(size(paths_list));
    fig6b.gold_db = zeros(size(paths_list));
    fig6b.zc_db = zeros(size(paths_list));
    fig6b.random_db = zeros(size(paths_list));
    fig6b.bound_db = zeros(size(paths_list));
    fig6b.notes = ['Gold uses a standard length-31 preferred-pair ' ...
        'construction. CAN is omitted because official CAN coefficients ' ...
        'were not available.'];

    for idx = 1:length(paths_list)
        channel_len = paths_list(idx);
        fig6b.proposed_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_czcp, channel_len));
        fig6b.gcp_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_gcp, channel_len));
        fig6b.mseq_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_mseq, channel_len));
        fig6b.barker_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_barker, channel_len));
        fig6b.gold_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_gold, channel_len));
        fig6b.zc_db(idx) = 10 * log10(noise_var * mse_trace_factor(Omega_zc, channel_len));
        fig6b.bound_db(idx) = 10 * log10(noise_var / E_target);

        random_trace = 0;
        for trial = 1:random_trials
            Omega_random = normalize_training_energy( ...
                build_structure48_from_rows(2 * randi([0, 1], Nt, 32) - 1), E_target);
            random_trace = random_trace + mse_trace_factor(Omega_random, channel_len);
        end
        fig6b.random_db(idx) = 10 * log10(noise_var * random_trace / random_trials);
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
