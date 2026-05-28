clearvars; close all; clc;

q = 4;
omega4 = exp(1i * 2 * pi / q);
N = 9;
Z = 3;
PI_CONST = 3.141592653589793;

exp_a = [0,1,1,2,0,2,1,1,3];
exp_b = [0,1,1,0,1,0,3,3,1];

a = omega4 .^ exp_a;
b = omega4 .^ exp_b;

fprintf('Output\n');
fprintf('Output: %d, %d\n', N, Z);
fprintf('Output: %s\n', num2str(exp_a));
fprintf('Output: %s\n', num2str(exp_b));

a_rev = flip(a);
b_rev = flip(b);

b_rev_conj = conj(b_rev);
minus_a_rev_conj = -conj(a_rev);

exp_b_rev_conj = round(angle(b_rev_conj) / (2*PI_CONST/q));
exp_b_rev_conj(exp_b_rev_conj < 0) = exp_b_rev_conj(exp_b_rev_conj < 0) + q;

exp_minus_a_rev_conj = round(angle(minus_a_rev_conj) / (2*PI_CONST/q));
exp_minus_a_rev_conj(exp_minus_a_rev_conj < 0) = exp_minus_a_rev_conj(exp_minus_a_rev_conj < 0) + q;

expected_b_rev_conj = [3,1,1,0,3,0,3,3,0];
expected_minus_a_rev_conj = [3,1,1,0,2,0,1,1,2];

fprintf('Output: %s\n', num2str(exp_b_rev_conj));
fprintf('Output: %s\n', num2str(exp_minus_a_rev_conj));

fprintf('Output\n');
[tau_all, rho_bc] = aperiodic_autocorr(b_rev_conj);
[~, rho_mac] = aperiodic_autocorr(minus_a_rev_conj);
AAC_sum_new = rho_bc + rho_mac;
tau_pos = tau_all(tau_all >= 0);
AAC_sum_mag = abs(AAC_sum_new(tau_all >= 0));

fprintf('Output\n');
disp(AAC_sum_mag);

T1 = 1:Z;
T2 = (N-Z):(N-1);
idx_C1 = ismember(tau_pos, [T1, T2]);
valid_C1_new = all(abs(AAC_sum_mag(idx_C1)) < 1e-10);
if valid_C1_new
    fprintf('Output\n');
end

fprintf('Output\n');
[~, rho_a_bc] = aperiodic_crosscorr(a, b_rev_conj);
[~, rho_b_mac] = aperiodic_crosscorr(b, minus_a_rev_conj);
ACC_sum_orth = rho_a_bc + rho_b_mac;
ACC_sum_orth_mag = abs(ACC_sum_orth(tau_all >= 0));

fprintf('Orthogonality check for derived pair:\n');

valid_orth = all(abs(ACC_sum_orth_mag) < 1e-10);
if valid_orth
    fprintf('Output\n');
end

fprintf('Output\n');
[~, rho_bc_mac] = aperiodic_crosscorr(b_rev_conj, minus_a_rev_conj);
[~, rho_mac_bc] = aperiodic_crosscorr(minus_a_rev_conj, b_rev_conj);
ACC_sum_new = rho_bc_mac + rho_mac_bc;
ACC_sum_new_mag = abs(ACC_sum_new(tau_all >= 0));

fprintf('Output\n');
disp(ACC_sum_new_mag);

idx_T2 = ismember(tau_pos, T2);
valid_C2_new = all(abs(ACC_sum_new_mag(idx_T2)) < 1e-10);
if valid_C2_new
    fprintf('Output\n');
end

if valid_C1_new && valid_orth && valid_C2_new
    fprintf('Output\n');
    fprintf('Output\n');
else
    fprintf('Output\n');
end
