clear; clc; close all;

% Implementation note.
function [is_valid, results] = verify_czcp(a, b, Z)
    N = length(a);
    [tau_all, rho_a] = aperiodic_autocorr(a);
    [~, rho_b] = aperiodic_autocorr(b);
    [~, rho_ab] = aperiodic_crosscorr(a, b);
    [~, rho_ba] = aperiodic_crosscorr(b, a);
    
    % Implementation note.
    T1 = 1:Z;
    T2 = (N-Z):(N-1);
    idx_C1 = ismember(abs(tau_all), [T1, T2]);  % Implementation note.
    idx_C2 = ismember(abs(tau_all), T2);  % Implementation note.
    
    % Implementation note.
    C1_vals = rho_a(idx_C1) + rho_b(idx_C1);
    C2_vals = rho_ab(idx_C2) + rho_ba(idx_C2);
    
    is_valid_C1 = all(abs(C1_vals) < 1e-10);
    is_valid_C2 = all(abs(C2_vals) < 1e-10);
    
    is_valid = is_valid_C1 && is_valid_C2;
    results.C1_vals = C1_vals;
    results.C2_vals = C2_vals;
    results.tau_C1 = tau_all(idx_C1);
    results.tau_C2 = tau_all(idx_C2);
end

% Implementation note.
q = 4;  % Implementation note.
mu = 2;  % Implementation note.
M = 2^mu;  % Implementation note.

% Implementation note.
kappa = 0:M-1;
x1 = floor(kappa / 2);  % Implementation note.
x2 = mod(kappa, 2);  % Implementation note.
g = (q/2)*x1.*x2;       % GBF: g(x) = (q/2)x1x2
g_prime = g + (q/2)*x1; % GBF: g' = g + (q/2)x1

% Implementation note.
omega_q = exp(1i*2*pi/q);
e = omega_q.^g;
f = omega_q.^g_prime;

fprintf('Output\n');
fprintf('Output: %d, %d\n', M, q);
disp('Output'); disp(e);
disp('Output'); disp(f);

v1 = 0;
v2 = q/2;  % Implementation note.
v = 1;

fprintf('Output\n');
fprintf('v1 = %d, v2 = %d, v = %d\n', v1, v2, v);
fprintf('Output: %d, %d\n', mod(v1-v2, q), q);

% Implementation note.
czcp_set = generate_czcp_set(e, f, q, v1, v2, v);
N = 2*M;  % Implementation note.
Z = M;  % Implementation note.

fprintf('Output\n');
fprintf('Output: %d, %d\n', N, Z);

% Implementation note.
% Implementation note.
a1 = czcp_set(1).a;
b1 = czcp_set(1).b;

[tau_all, rho_ab1] = aperiodic_crosscorr(a1, b1);
[~, rho_ba1] = aperiodic_crosscorr(b1, a1);
ACC_sum = rho_ab1 + rho_ba1;

coeff_left = (-omega_q^(v1-v2) + omega_q^(v2-v1));

fprintf('Output\n');
fprintf('Output: %.4f\n', coeff_left);
if abs(coeff_left) < 1e-10
    fprintf('Output\n');
end

% Implementation note.
idx_T2 = ismember(abs(tau_all), (N-Z):(N-1));
fprintf('Output\n');
disp(ACC_sum(idx_T2));

% Implementation note.
[is_valid, results] = verify_czcp(a1, b1, Z);

fprintf('Output\n');
if is_valid
    fprintf('Output\n');
    fprintf('Output\n');
else
    fprintf('Output\n');
end
