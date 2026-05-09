% 函数C2：计算两个序列的非周期互相关(ACC) ρ(x,y)(τ)
% 输入：x, y - 两个复值序列（长度相同）
% 输出：tau - 时延向量（从-(N-1)到N-1）
%       rho_xy - 对应时延的ACC值
function [tau, rho_xy] = aperiodic_crosscorr(x, y)
    x = x(:).'; y = y(:).';  % 统一转为行向量
    N = length(x);
    tau = -(N-1):N-1;
    rho_xy = zeros(size(tau));
    
    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % τ ≥ 0 时：ρ(x,y)(τ) = sum_{n=0}^{N-τ-1} x(n+1) * conj(y(n+τ+1))
            sum_term = x(1:N-t) .* conj(y(1+t:N));
        else
            % τ < 0 时：ρ(x,y)(τ) = sum_{n=0}^{N+τ-1} x(n-τ+1) * conj(y(n+1))
            sum_term = x(1-t:N) .* conj(y(1:N+t));
        end
        rho_xy(idx) = sum(sum_term);
    end
end