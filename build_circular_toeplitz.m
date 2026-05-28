function T = build_circular_toeplitz(x, channel_len)
% 构造循环卷积训练矩阵。
%   T 的尺寸为 L-by-channel_len；第 ell 列为 x 循环延迟 ell - 1 后的结果。

    x = x(:);
    L = length(x);
    T = zeros(L, channel_len);

    for ell = 0:channel_len-1
        T(:, ell + 1) = circshift(x, ell);
    end
end
