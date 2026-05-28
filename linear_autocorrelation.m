function rho = linear_autocorrelation(x, tau)
% 计算非负时延的线性自相关。

    x = x(:);
    N = length(x);

    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    rho = 0;
    for n = 0:N - 1 - tau
        x_n = x(n + 1);
        x_n_tau = x(n + tau + 1);
        rho = rho + x_n * conj(x_n_tau);
    end
end
