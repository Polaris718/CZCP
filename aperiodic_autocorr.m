function [tau, rho_x] = aperiodic_autocorr(x)
%APERIODIC_AUTOCORR Compute the full aperiodic autocorrelation of x.

    x = x(:).';
    N = length(x);
    tau = -(N-1):N-1;
    rho_x = zeros(size(tau));

    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % Positive lags compare x(n) with x(n + t).
            sum_term = x(1:N-t) .* conj(x(1+t:N));
        else
            % Negative lags use the conjugate symmetry of autocorrelation.
            sum_term = conj(x(1:N+t) .* conj(x(1-t:N)));
        end
        rho_x(idx) = sum(sum_term);
    end
end
