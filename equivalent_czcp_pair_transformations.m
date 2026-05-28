clear; clc; close all;


N = 9; Z = 3;
omega4 = exp(1i * 2 * pi / 4);

a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];

b_rev_conj_expected = omega4.^[3, 1, 1, 0, 3, 0, 3, 3, 0];
a_rev_conj_neg_expected = omega4.^[3, 1, 1, 0, 2, 0, 1, 1, 2];

T1 = 1:Z;
T2 = (N-Z):(N-1);
tau_all = -(N-1):(N-1);

c1 = 1;
c2 = 1;
a_new = c1 * b;
b_new = c2 * a;

[~, rho_a_new] = aperiodic_autocorr(a_new);
[~, rho_b_new] = aperiodic_autocorr(b_new);
[~, rho_ab_new] = aperiodic_crosscorr(a_new, b_new);
[~, rho_ba_new] = aperiodic_crosscorr(b_new, a_new);

idx_C1 = ismember(abs(tau_all), [T1, T2]);
idx_C2 = ismember(abs(tau_all), T2);

C1_check = rho_a_new(idx_C1) + rho_b_new(idx_C1);
C2_check = rho_ab_new(idx_C2) + rho_ba_new(idx_C2);

cond_p2_1 = all(abs(C1_check) < 1e-10) && all(abs(C2_check) < 1e-10);


[~, rho_brc] = aperiodic_autocorr(b_rev_conj_expected);
[~, rho_arcn] = aperiodic_autocorr(a_rev_conj_neg_expected);
AAC_sum = rho_brc + rho_arcn;

[~, rho_a_brc] = aperiodic_crosscorr(a, b_rev_conj_expected);
[~, rho_b_arcn] = aperiodic_crosscorr(b, a_rev_conj_neg_expected);
ACC_sum_1 = rho_a_brc + rho_b_arcn;

[~, rho_b_brc] = aperiodic_crosscorr(b, b_rev_conj_expected);
[~, rho_a_arcn] = aperiodic_crosscorr(a, a_rev_conj_neg_expected);
ACC_sum_2 = rho_b_brc + rho_a_arcn;

cond_p2_2 = all(abs(AAC_sum(idx_C1)) < 1e-10);
cond_p2_3 = all(abs(ACC_sum_1) < 1e-10);
cond_p2_4 = all(abs(ACC_sum_2(idx_C2)) < 1e-10);

disp('Output');

if cond_p2_1
    disp('Output');
else
    disp('Output');
end

if cond_p2_2
    disp('Output');
end

if cond_p2_3
    disp('Output');
end

if cond_p2_4
    disp('Output');
end

if cond_p2_1 && cond_p2_2 && cond_p2_3 && cond_p2_4
    disp(' ');
    disp('Output');
end
