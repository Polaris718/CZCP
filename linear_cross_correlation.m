function rho = linear_cross_correlation(a, b, tau)
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。

    a = a(:);  % 实现说明。
    b = b(:);
    N = length(a);

    % 实现说明。
    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    rho = 0;
    % 实现说明。
    for n = 0 : N-1-tau
        a_idx = n + 1;  % 实现说明。
        b_idx = n + tau + 1;  % 实现说明。
        rho = rho + a(a_idx) * conj(b(b_idx));
    end
end
