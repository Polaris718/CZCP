function T = build_circular_toeplitz(x, channel_len)
    %BUILD_CIRCULAR_TOEPLITZ 为单个天线构造循环卷积训练矩阵。
    %   T的尺寸为L-by-channel_len，第ell列为x循环延迟ell-1后的结果。

    x = x(:);
    L = length(x);
    T = zeros(L, channel_len);

    for ell = 0:channel_len-1
        T(:, ell + 1) = circshift(x, ell);
    end
end
