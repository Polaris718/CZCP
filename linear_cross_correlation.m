function rho = linear_cross_correlation(a, b, tau)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    
    a = a(:);  % Implementation note.
    b = b(:);
    N = length(a);
    
    % Implementation note.
    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end
    
    rho = 0;
    % Implementation note.
    for n = 0 : N-1-tau
        a_idx = n + 1;  % Implementation note.
        b_idx = n + tau + 1;  % Implementation note.
        rho = rho + a(a_idx) * conj(b(b_idx));
    end
end
