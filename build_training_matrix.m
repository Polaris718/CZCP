function X = build_training_matrix(Omega, channel_len)
%BUILD_TRAINING_MATRIX Build the stacked training matrix X.
%   Omega is Nt-by-L. X is L-by-(Nt*channel_len), formed by concatenating
%   one circular Toeplitz block per transmit antenna.

    [Nt, ~] = size(Omega);
    blocks = cell(1, Nt);

    for nt = 1:Nt
        blocks{nt} = build_circular_toeplitz(Omega(nt, :).', channel_len);
    end

    X = [blocks{:}];
end
