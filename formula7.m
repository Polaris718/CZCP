% Implementation note.
clear; clc;

%% Verification or construction step
mu = 3;  % Implementation note.
q = 4;  % Implementation note.
% Implementation note.
g = [0, 1, 2, 3, 4, 5, 6, 7];  

%% Verification or construction step
% Implementation note.
omega_q = exp(-1j * 2 * pi / q);

% Implementation note.
phi_q_g = omega_q .^ g;

%% Verification or construction step
disp('Output');
disp(['Output', num2str(mu), 'Output', num2str(2^mu)]);
disp(['Output', num2str(q), 'Output', num2str(q), ' = ']);
disp(omega_q);
disp(['Output', num2str(q), 'Output']);
disp(phi_q_g);

% Implementation note.
phi_mag = abs(phi_q_g);
disp('Output');
disp(phi_mag);

%% Verification or construction step
% len_g = 2^mu;
% g = 0 : len_g - 1;
