function X = build_training_matrix(Omega, channel_len)
% 构造堆叠后的训练矩阵 X。
%   Omega 的尺寸为 Nt-by-L。X 的尺寸为 L-by-(Nt*channel_len)，由
%   每根发射天线对应的循环 Toeplitz 块拼接得到。

    [Nt, ~] = size(Omega);
    blocks = cell(1, Nt);

    for nt = 1:Nt
        blocks{nt} = build_circular_toeplitz(Omega(nt, :).', channel_len);
    end

    X = [blocks{:}];
end
