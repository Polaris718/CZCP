function T_tau = cyclic_shift(x, tau)
% 将向量向右循环移位 tau 个采样点。

    x = x(:);
    N = length(x);

    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    if tau == 0
        T_tau = x;
        return;
    end

    last_tau_elements = x(N - tau + 1:N);
    first_N_tau_elements = x(1:N - tau);
    T_tau = [last_tau_elements; first_N_tau_elements];
end
