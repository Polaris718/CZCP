function rho = full_linear_cross_correlation(a, b, tau)
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。

    % 实现说明。
    a = a(:);
    b = b(:);
    N = length(a);

    % 实现说明。
    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end

    % 实现说明。
    if abs(tau) >= N
        % 实现说明。
        rho = 0;
    elseif tau >= 0 && tau <= N-1
        % 实现说明。
        rho = 0;
        for n = 0 : N - tau - 1
            a_idx = n + 1;  % 实现说明。
            b_idx = n + tau + 1;  % 实现说明。
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    elseif tau >= -(N-1) && tau <= -1
        % 实现说明。
        rho = 0;
        for n = 0 : N + tau - 1
            a_idx = n - tau + 1;  % 实现说明。
            b_idx = n + 1;  % 实现说明。
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    else
        % 实现说明。
        rho = 0;
    end
end
