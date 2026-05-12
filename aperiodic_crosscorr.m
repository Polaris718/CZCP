% Implementation note.
% Implementation note.
% Implementation note.
% Implementation note.
function [tau, rho_xy] = aperiodic_crosscorr(x, y)
    x = x(:).'; y = y(:).';  % Implementation note.
    N = length(x);
    tau = -(N-1):N-1;
    rho_xy = zeros(size(tau));
    
    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % Implementation note.
            sum_term = x(1:N-t) .* conj(y(1+t:N));
        else
            % Implementation note.
            sum_term = x(1-t:N) .* conj(y(1:N+t));
        end
        rho_xy(idx) = sum(sum_term);
    end
end
