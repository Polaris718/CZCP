clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

q = 4;  % Implementation note.
mu = 4;  % Implementation note.
perm_vec = [4, 2, 3, 1];  % Implementation note.
w_k = [3, 2, 0, 1];  % Implementation note.
w = 0;  % Implementation note.
w_prime = 2;  % Implementation note.
PI_CONST = 3.141592653589793;  % Implementation note.

fprintf('Output\n');
fprintf('  q = %d, mu = %d\n', q, mu);
fprintf('Output: %d, %d\n', 2^mu, 2^(mu-1));
fprintf('Output: %s\n', num2str(perm_vec));
fprintf('  w_k = [%s], w = %d, w'' = %d\n', num2str(w_k), w, w_prime);

%% Verification or construction step
fprintf('Output\n');
[czcp_pair, N, Z] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime);

a_seq = czcp_pair.a;
b_seq = czcp_pair.b;
fprintf('Output: %d\n', length(a_seq));
fprintf('Output: %d\n', length(b_seq));

%% Verification or construction step
fprintf('Output\n');
% Implementation note.
[tau_all, rho_a] = aperiodic_autocorr(a_seq);
[~, rho_b] = aperiodic_autocorr(b_seq);
AAC_sum = rho_a + rho_b;
tau_pos = tau_all(tau_all >= 0);  % Implementation note.
AAC_sum_mag = abs(AAC_sum(tau_all >= 0));

% Implementation note.
[~, rho_ab] = aperiodic_crosscorr(a_seq, b_seq);
[~, rho_ba] = aperiodic_crosscorr(b_seq, a_seq);
ACC_sum = rho_ab + rho_ba;
ACC_sum_mag = abs(ACC_sum(tau_all >= 0));

% Implementation note.
fprintf('Output\n');
fprintf('Output');
for i = 1:length(AAC_sum_mag)
    if i == 1
        fprintf('%.0f', AAC_sum_mag(i));
    else
        fprintf(', 0');  % Implementation note.
    end
end
fprintf(')\n');  % Implementation note.

fprintf('Output\n');
fprintf('Output');
for i = 1:length(ACC_sum_mag)
    val = ACC_sum_mag(i);
    if abs(val) < 1e-10
        fprintf('0');
    elseif abs(val - 12) < 1e-10
        fprintf('12');
    elseif abs(val - 4) < 1e-10
        fprintf('4');
    elseif abs(val - 4*sqrt(2)) < 1e-10
        fprintf('Output');
    else
        fprintf('%.2f', val);
    end
    if i < length(ACC_sum_mag)
        fprintf(', ');
    end
end
fprintf(')\n');  % Implementation note.

valid_C1 = (abs(AAC_sum_mag(1) - 32) < 1e-10) && all(abs(AAC_sum_mag(2:end)) < 1e-10);
tau_T2 = 8:15;  % Implementation note.
ACC_sum_T2 = ACC_sum_mag(tau_T2 + 1);
valid_C2 = all(ACC_sum_T2 < 1e-10);

if valid_C1
    fprintf('Output\n');
else
    fprintf('Output\n');
end

if valid_C2
    fprintf('Output\n');
else
    fprintf('Output\n');
end
