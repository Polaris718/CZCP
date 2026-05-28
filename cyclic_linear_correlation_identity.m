% Verify formula (3):
% phi(a,b)(tau) = rho(a,b)(tau) + conj(rho(b,a)(N-tau)).
clear;
clc;

% Real test vectors; conjugation does not change these values.
N = 5;
a = [1; 2; 3; 4; 5];
b = [2; 4; 6; 8; 10];
tau = 2;

% Left side: cyclic cross-correlation.
phi = cyclic_cross_correlation(a, b, tau);

% First right-side term: linear cross-correlation rho(a,b)(tau).
rho_ab = linear_cross_correlation(a, b, tau);

% Second right-side term: conj(rho(b,a)(N-tau)).
tau_prime = N - tau;
rho_ba = linear_cross_correlation(b, a, tau_prime);
rho_ba_conj = conj(rho_ba);

right_side = rho_ab + rho_ba_conj;

disp('=== Formula (3) verification result ===');
disp(['Cyclic cross-correlation phi(a,b)(', num2str(tau), ') = ', num2str(phi)]);
disp(['Linear cross-correlation rho(a,b)(', num2str(tau), ') = ', num2str(rho_ab)]);
disp(['Linear cross-correlation rho(b,a)(', num2str(tau_prime), ') = ', num2str(rho_ba)]);
disp(['Right side rho(a,b)(tau) + conj(rho(b,a)(N-tau)) = ', num2str(right_side)]);
disp(['Identity holds: ', num2str(abs(phi - right_side) < 1e-10)]);
