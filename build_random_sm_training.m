function Omega = build_random_sm_training(Nt, theta, J, alphabet_order)
    %BUILD_RANDOM_SM_TRAINING 构造同支撑集的随机稀疏SM训练基线。
    %   支撑集和能量与build_czcp_sm_training一致，非零符号为
    %   随机q-PSK元素。

    if nargin < 4
        alphabet_order = 4;
    end
    if mod(Nt, 2) ~= 0
        error('Nt must be even.');
    end
    if mod(J, 2) ~= 0
        error('J must be even.');
    end

    Omega_e = zeros(Nt, 2 * Nt * theta);
    omega_q = exp(1i * 2 * pi / alphabet_order);

    for nt = 1:Nt
        first_idx = (nt - 1) * theta + (1:theta);
        second_idx = (Nt + nt - 1) * theta + (1:theta);
        Omega_e(nt, first_idx) = omega_q .^ randi([0, alphabet_order - 1], 1, theta);
        Omega_e(nt, second_idx) = omega_q .^ randi([0, alphabet_order - 1], 1, theta);
    end

    Omega = repmat(Omega_e, 1, J / 2);
end
