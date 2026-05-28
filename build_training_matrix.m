function X = build_training_matrix(Omega, channel_len)
    %BUILD_TRAINING_MATRIX 构造第四节使用的堆叠训练矩阵X。
    %   Omega的尺寸为Nt-by-L。X的尺寸为L-by-(Nt*channel_len)，
    %   由各发射天线行对应的循环Toeplitz矩阵拼接得到。

    [Nt, ~] = size(Omega);
    blocks = cell(1, Nt);

    for nt = 1:Nt
        blocks{nt} = build_circular_toeplitz(Omega(nt, :).', channel_len);
    end

    X = [blocks{:}];
end
