% Implementation note.
% Implementation note.
% Implementation note.
% Implementation note.
function [tau, rho_x] = aperiodic_autocorr(x)
    x = x(:).';  % Implementation note.
    N = length(x);
    tau = -(N-1):N-1;
    rho_x = zeros(size(tau));
    
    for idx = 1:length(tau)
        t = tau(idx);
        if t >= 0
            % Implementation note.
            sum_term = x(1:N-t) .* conj(x(1+t:N));
        else
            % Implementation note.
            sum_term = conj(x(1:N+t) .* conj(x(1-t:N)));
        end
        rho_x(idx) = sum(sum_term);
    end
end

