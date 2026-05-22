function T_tau = cyclic_shift(x, tau)
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    
    % 实现说明。
    x = x(:);
    % 实现说明。
    N = length(x);
    
    % 实现说明。
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end
    
    % 实现说明。
    if tau == 0
        T_tau = x;
        return;
    end
    
    % 实现说明。
    last_tau_elements = x(N - tau + 1 : N);  % 实现说明。
    first_N_tau_elements = x(1 : N - tau);  % 实现说明。
    
    % 实现说明。
    T_tau = [last_tau_elements; first_N_tau_elements];
end
