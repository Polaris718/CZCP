function rho = linear_autocorrelation(x, tau)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    
    x = x(:);  % Implementation note.
    N = length(x);
    
    % Implementation note.
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end
    
    % Implementation note.
    rho = 0;
    for n = 0 : N-1-tau
        x_n = x(n+1);  % Implementation note.
        x_n_tau = x(n+tau+1);  % Implementation note.
        rho = rho + x_n * conj(x_n_tau);
    end
end
