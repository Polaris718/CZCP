clear; clc; close all;

q = 4;
omega4 = exp(1i*2*pi/q);
M = 11;
N = 2*M;
Z = M;

exp_e = [0, 1, 2, 0, 2, 1, 3, 2, 1, 1, 0];
exp_f = [0, 0, 3, 3, 3, 0, 0, 1, 2, 0, 2];

e = omega4.^exp_e;
f = omega4.^exp_f;

v1 = 0;
v2 = 0;
v = 1;

fprintf('Output\n');
fprintf('Output: %d, %d\n', q, M);
fprintf('Output: %d, %d, %d\n', v1, v2, v);
fprintf('Output: %d\n', v1-v2);

czcp_set = generate_czcp_set(e, f, q, v1, v2, v);
a1 = czcp_set(1).a;  % CZCP 参数。
b1 = czcp_set(1).b;

exp_a1 = round(angle(a1)/(2*pi/q));
exp_a1(exp_a1<0) = exp_a1(exp_a1<0) + q;
exp_b1 = round(angle(b1)/(2*pi/q));
exp_b1(exp_b1<0) = exp_b1(exp_b1<0) + q;

fprintf('Output\n');
fprintf('Output\n');
disp(exp_a1);
fprintf('Output\n');
disp(exp_b1);

[tau_all, rho_a] = aperiodic_autocorr(a1);
[~, rho_b] = aperiodic_autocorr(b1);
AAC_sum = rho_a + rho_b;

tau_pos = 0:N-1;
AAC_sum_mag = abs(AAC_sum(tau_all >= 0));

fprintf('Output\n');
disp(AAC_sum_mag);
if abs(AAC_sum_mag(1) - 44) < 1e-10 && all(abs(AAC_sum_mag(2:end)) < 1e-10)
    fprintf('Output\n');
end

[~, rho_ab] = aperiodic_crosscorr(a1, b1);
[~, rho_ba] = aperiodic_crosscorr(b1, a1);
ACC_sum = rho_ab + rho_ba;
ACC_sum_mag = abs(ACC_sum(tau_all >= 0));

fprintf('Output\n');
disp(ACC_sum_mag);

tau_T2 = 11:21;
ACC_sum_T2 = ACC_sum_mag(tau_T2+1);
if all(abs(ACC_sum_T2) < 1e-10)
    fprintf('Output\n');
end
