function Omega = build_czcp_sm_training(a, b, Nt, J, seed_type)
%BUILD_CZCP_SM_TRAINING 由CZCP构造稀疏SM训练矩阵。
%   a,b       - 长度同为theta的CZCP序列。
%   Nt        - 发射天线数，必须为偶数。
%   J         - training repetition factor, must be even.
%   seed_type - 1使用行[a,b]；2使用[a,b]与[conj(flip(b)),-conj(flip(a))]。
%
%   返回矩阵尺寸为Nt-by-(Nt*J*theta)。每个天线行含有J个
%   长度为theta的非零块，因此每个天线的训练能量为J*theta。

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

