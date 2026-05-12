function T_tau = cyclic_shift(x, tau)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    
    % Implementation note.
    x = x(:);
    % Implementation note.
    N = length(x);
    
    % Implementation note.
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end
    
    % Implementation note.
    if tau == 0
        T_tau = x;
        return;
    end
    
    % Implementation note.
    last_tau_elements = x(N - tau + 1 : N);  % Implementation note.
    first_N_tau_elements = x(1 : N - tau);  % Implementation note.
    
    % Implementation note.
    T_tau = [last_tau_elements; first_N_tau_elements];
end
