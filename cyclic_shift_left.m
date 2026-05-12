function T_minus_tau = cyclic_shift_left(x, tau)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    
    % Implementation note.
    x = x(:);
    N = length(x);
    
    % Implementation note.
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end
    
    % Implementation note.
    if tau == 0
        T_minus_tau = x;
        return;
    end
    
    % Implementation note.
    % Implementation note.
    part1 = x(tau + 1 : N);
    % Implementation note.
    part2 = x(1 : tau);
    
    % Implementation note.
    T_minus_tau = [part1; part2];
end
