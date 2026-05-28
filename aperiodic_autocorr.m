% 实现说明。
% 实现说明。
% 实现说明。
% 实现说明。
function [tau, rho_x] = aperiodic_autocorr(x)
    x = x(:).';  % 实现说明。
    N = length(x);
    tau = -(N-1):N-1;
    rho_x = zeros(size(tau));

    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % 实现说明。
            sum_term = x(1:N-t) .* conj(x(1+t:N));
        else
            % 实现说明。
            sum_term = conj(x(1:N+t) .* conj(x(1-t:N)));
        end
        rho_x(idx) = sum(sum_term);
    end
end
