function Omega = build_czcp_sm_training(a, b, Nt, J, seed_type)
% 由 CZCP 序列对构造稀疏 SM 训练矩阵。
%   a,b       - 长度同为 theta 的 CZCP 序列。
%   Nt        - 发射天线数，必须为偶数。
%   J         - 训练重复因子，必须为偶数。
%   seed_type - 1 表示所有天线均使用 [a,b]；2 表示前半部分使用 [a,b]，
%           后半部分使用 [conj(flip(b)),-conj(flip(a))]。
%
%   Omega 的尺寸为 Nt-by-(Nt*J*theta)。每个天线行包含 J 个非零块，
%   每个块长度为 theta，因此每根天线的训练能量为 J*theta。

    if nargin < 5
        seed_type = 1;
    end

    a = a(:).';
    b = b(:).';
    theta = length(a);

    if length(b) ~= theta
        error('a and b must have the same length.');
    end
    if mod(Nt, 2) ~= 0
        error('Nt must be even.');
    end
    if mod(J, 2) ~= 0
        error('J must be even.');
    end

    char_blocks = cell(Nt, 2);
    for nt = 1:Nt
        if seed_type == 1 || nt <= Nt / 2
            char_blocks{nt, 1} = a;
            char_blocks{nt, 2} = b;
        elseif seed_type == 2
            char_blocks{nt, 1} = conj(fliplr(b));
            char_blocks{nt, 2} = -conj(fliplr(a));
        else
            error('seed_type must be 1 or 2.');
        end
    end

    Omega_e = zeros(Nt, 2 * Nt * theta);
    for nt = 1:Nt
        first_idx = (nt - 1) * theta + (1:theta);
        second_idx = (Nt + nt - 1) * theta + (1:theta);
        Omega_e(nt, first_idx) = char_blocks{nt, 1};
        Omega_e(nt, second_idx) = char_blocks{nt, 2};
    end

    Omega = repmat(Omega_e, 1, J / 2);
end
