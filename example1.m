clear; clc;
%% Verification or construction step
%% Verification or construction step
kappa_set = [0 0 0;1 0 0;0 1 0;1 1 0;0 0 1;1 0 1;0 1 1;1 1 1];
one_vec  = [1,1,1,1,1,1,1,1];
x1_vec   = [0,1,0,1,0,1,0,1];
x3_vec   = [0,0,0,0,1,1,1,1];
calc_vec = 2 * x1_vec .* x3_vec + one_vec;
disp('Output'); disp(calc_vec);
% Implementation note.
mu = 4;
q = 8;
N = 2^mu;
%% Verification or construction step
g = 0:N-1;
disp('Output'); disp(g);
%% Verification or construction step
omega_q = exp(-1j*2*pi/q);
phi_g = omega_q .^ g;
disp('Output'); disp(phi_g);
%% Verification or construction step
h = [0,2,4,6,1,3,5,7,8,10,12,14,9,11,13,15];
phi_h = omega_q .^ h;
tau = 2; 
function rho = full_cross_corr(a,b,tau)
    a = a(:); b = b(:); len = length(a);
    if abs(tau) >= len, rho=0;
    elseif tau >= 0, rho=sum(a(1:len-tau).*conj(b(tau+1:len)));
    else, rho=sum(a(-tau+1:len).*conj(b(1:len+tau))); end
end
rho_q = full_cross_corr(phi_g, phi_h, tau);
disp(['Output',num2str(tau),') ===']); disp(rho_q);
%% Verification or construction step
x = [1,0,1,0];
pi_vec = [1,2,3,4];
w = [1,1,1,1]; w_const = 0;
term1 = (q/2)*sum(x(pi_vec(1:end-1)).*x(pi_vec(2:end)));
term2 = sum(w.*x);
g_x = term1 + term2 + w_const;
