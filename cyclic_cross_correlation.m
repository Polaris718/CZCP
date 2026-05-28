function phi = cyclic_cross_correlation(a, b, tau, method)
%CYCLIC_CROSS_CORRELATION Compute cyclic cross-correlation at lag tau.
%   method can be 'inner' or 'sum'. Both implement
%   phi(a,b)(tau) = sum_n a(n) * conj(b(n + tau mod N)).

    if nargin < 4
        method = 'inner';
    end

    a = a(:);
    b = b(:);
    N = length(a);

    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    if strcmp(method, 'inner')
        b_shift = cyclic_shift_left(b, tau);
        phi = a.' * conj(b_shift);
    elseif strcmp(method, 'sum')
        phi = 0;
        for n = 0:N-1
            idx = mod(n + tau, N) + 1;
            phi = phi + a(n + 1) * conj(b(idx));
        end
    else
        error('method must be ''inner'' or ''sum''.');
    end
end
