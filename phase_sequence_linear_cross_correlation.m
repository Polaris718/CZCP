clear;
clc;

%% Parameters
mu = 3;
q = 4;
tau = 2;
g = 0:2^mu - 1;
h = [0, 2, 4, 6, 1, 3, 5, 7];

%% Build Phase Sequences and Correlate
phi_q_g = gen_phi_q(g, q);
phi_q_h = gen_phi_q(h, q);
rho_q_gh = full_linear_cross_correlation(phi_q_g, phi_q_h, tau);

%% Display
disp(['mu = ', num2str(mu), ', q = ', num2str(q), ', tau = ', num2str(tau)]);
disp('Index sequences:');
disp(g);
disp(h);
disp('Phase sequences:');
disp(phi_q_g);
disp(phi_q_h);
disp(['rho_q(g,h)(', num2str(tau), ') = ']);
disp(rho_q_gh);

test_taus = [-3, -1, 0, 2, 3];
disp('Additional lags:');
for t = test_taus
    rho_tmp = full_linear_cross_correlation(phi_q_g, phi_q_h, t);
    disp(['tau = ', num2str(t), ', rho = ', num2str(rho_tmp)]);
end
