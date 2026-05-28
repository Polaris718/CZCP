function [tau, rho_xy] = aperiodic_crosscorr(x, y)
% 计算完整非周期互相关。

    x = x(:).';
    y = y(:).';
    N = length(x);
    tau = -(N-1):N-1;
    rho_xy = zeros(size(tau));

    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % 正时延比较 x(n) 与 y(n + t)。
            sum_term = x(1:N-t) .* conj(y(1+t:N));
        else
            % 负时延比较 x(n - t) 与 y(n)。
            sum_term = x(1-t:N) .* conj(y(1:N+t));
        end
        rho_xy(idx) = sum(sum_term);
    end
end
