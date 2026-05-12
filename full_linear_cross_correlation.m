function rho = full_linear_cross_correlation(a, b, tau)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    
    % Implementation note.
    a = a(:);
    b = b(:);
    N = length(a);
    
    % Implementation note.
    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end
    
    % Implementation note.
    if abs(tau) >= N
        % Implementation note.
        rho = 0;
    elseif tau >= 0 && tau <= N-1
        % Implementation note.
        rho = 0;
        for n = 0 : N - tau - 1
            a_idx = n + 1;  % Implementation note.
            b_idx = n + tau + 1;  % Implementation note.
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    elseif tau >= -(N-1) && tau <= -1
        % Implementation note.
        rho = 0;
        for n = 0 : N + tau - 1
            a_idx = n - tau + 1;  % Implementation note.
            b_idx = n + 1;  % Implementation note.
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    else
        % Implementation note.
        rho = 0;
    end
end
