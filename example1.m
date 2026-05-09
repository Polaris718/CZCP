clear; clc;
%% 公式9：生成二进制编码
%% ========== 公式9：二进制编码 + 加权向量计算（流程源头） ==========
kappa_set = [0 0 0;1 0 0;0 1 0;1 1 0;0 0 1;1 0 1;0 1 1;1 1 1];
one_vec  = [1,1,1,1,1,1,1,1];
x1_vec   = [0,1,0,1,0,1,0,1];
x3_vec   = [0,0,0,0,1,1,1,1];
calc_vec = 2 * x1_vec .* x3_vec + one_vec;
disp('=== 公式9 二进制编码与加权向量 ==='); disp(calc_vec);
%基础参数
mu = 4;
q = 8;
N = 2^mu;
%% ========== 公式6：定义基础向量g ==========
g = 0:N-1;
disp('=== 公式6 基础向量g ==='); disp(g);
%% ========== 公式7：生成复指数序列φ_q(g) ==========
omega_q = exp(-1j*2*pi/q);
phi_g = omega_q .^ g;
disp('=== 公式7 复指数向量φ_q(g) ==='); disp(phi_g);
%% ========== 公式8：验证序列互相关特性 ==========
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
disp(['=== 公式8 互相关ρ_q(g,h)(τ=',num2str(tau),') ===']); disp(rho_q);
%% ========== 公式10：加权优化序列特性 ==========
x = [1,0,1,0];
pi_vec = [1,2,3,4];
w = [1,1,1,1]; w_const = 0;
term1 = (q/2)*sum(x(pi_vec(1:end-1)).*x(pi_vec(2:end)));
term2 = sum(w.*x);
g_x = term1 + term2 + w_const;