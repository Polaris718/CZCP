function T = build_circular_toeplitz(x, channel_len)
%BUILD_CIRCULAR_TOEPLITZ Build a circular convolution training matrix.
%   T is L-by-channel_len. Column ell is x circularly delayed by ell - 1.

    x = x(:);
    L = length(x);
    T = zeros(L, channel_len);

    for ell = 0:channel_len-1
        T(:, ell + 1) = circshift(x, ell);
    end
end
