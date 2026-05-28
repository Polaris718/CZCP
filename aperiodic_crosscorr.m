function [tau, rho_xy] = aperiodic_crosscorr(x, y)
%APERIODIC_CROSSCORR Compute the full aperiodic cross-correlation.

    x = x(:).';
    y = y(:).';
    N = length(x);
    tau = -(N-1):N-1;
    rho_xy = zeros(size(tau));

    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % Positive lags compare x(n) with y(n + t).
            sum_term = x(1:N-t) .* conj(y(1+t:N));
        else
            % Negative lags compare x(n - t) with y(n).
            sum_term = x(1-t:N) .* conj(y(1:N+t));
        end
        rho_xy(idx) = sum(sum_term);
    end
end
