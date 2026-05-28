function rho = linear_autocorrelation(x, tau)
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。

    x = x(:);  % 实现说明。
    N = length(x);

    % 实现说明。
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    % 实现说明。
    rho = 0;
    for n = 0 : N-1-tau
        x_n = x(n+1);  % 实现说明。
        x_n_tau = x(n+tau+1);  % 实现说明。
        rho = rho + x_n * conj(x_n_tau);
    end
end
