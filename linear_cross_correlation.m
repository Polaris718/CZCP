function rho = linear_cross_correlation(a, b, tau)
%LINEAR_CROSS_CORRELATION Compute nonnegative-lag linear cross-correlation.

    a = a(:);
    b = b(:);
    N = length(a);

    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    rho = 0;
    for n = 0:N - 1 - tau
        a_idx = n + 1;
        b_idx = n + tau + 1;
        rho = rho + a(a_idx) * conj(b(b_idx));
    end
end
