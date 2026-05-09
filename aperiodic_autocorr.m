% 函数C1：计算序列的非周期自相关(AAC) ρ(x)(τ)
% 输入：x - 复值序列（行向量或列向量）
% 输出：tau - 时延向量（从-(N-1)到N-1）
%       rho_x - 对应时延的AAC值
function [tau, rho_x] = aperiodic_autocorr(x)
    x = x(:).';  % 统一转为行向量
    N = length(x);
    tau = -(N-1):N-1;
    rho_x = zeros(size(tau));
    
    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % τ ≥ 0 时：ρ(x)(τ) = sum_{n=0}^{N-τ-1} x(n+1) * conj(x(n+τ+1))
            sum_term = x(1:N-t) .* conj(x(1+t:N));
        else
            % τ < 0 时：利用 ρ(x)(τ) = conj(ρ(x)(-τ)) 简化计算
            sum_term = conj(x(1:N+t) .* conj(x(1-t:N)));
        end
        rho_x(idx) = sum(sum_term);
    end
end

