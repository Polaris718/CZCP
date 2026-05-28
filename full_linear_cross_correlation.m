function rho = full_linear_cross_correlation(a, b, tau)
% 计算任意时延下的线性互相关。

    a = a(:);
    b = b(:);
    N = length(a);

    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end

    if abs(tau) >= N
        rho = 0;
    elseif tau >= 0 && tau <= N-1
        rho = 0;
        for n = 0:N - tau - 1
            a_idx = n + 1;
            b_idx = n + tau + 1;
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    elseif tau >= -(N-1) && tau <= -1
        rho = 0;
        for n = 0:N + tau - 1
            a_idx = n - tau + 1;
            b_idx = n + 1;
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    else
        rho = 0;
    end
end
