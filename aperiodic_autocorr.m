function [tau, rho_x] = aperiodic_autocorr(x)
% 计算序列 x 的完整非周期自相关。

    x = x(:).';
    N = length(x);
    tau = -(N-1):N-1;
    rho_x = zeros(size(tau));

    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % 正时延比较 x(n) 与 x(n + t)。
            sum_term = x(1:N-t) .* conj(x(1+t:N));
        else
            % 负时延利用自相关的共轭对称性。
            sum_term = conj(x(1:N+t) .* conj(x(1-t:N)));
        end
        rho_x(idx) = sum(sum_term);
    end
end
