function Omega = build_czcp_sm_training(a, b, Nt, J, seed_type)
%BUILD_CZCP_SM_TRAINING Build a sparse SM training matrix from a CZCP.
%   a,b       - CZCP sequences with identical length theta.
%   Nt        - number of transmit antennas, must be even.
%   J         - repetition factor in the paper construction, must be even.
%   seed_type - 1 uses rows [a,b]; 2 uses [a,b] and [conj(flip(b)),-conj(flip(a))].
%
%   The returned matrix has size Nt-by-(Nt*J*theta). Every antenna row has
%   J nonzero theta-length blocks, so the per-antenna training energy is J*theta.

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

