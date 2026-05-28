function metrics = training_mse_metrics(Omega, channel_len, noise_var)
% 计算 Gram 矩阵、最优性误差和归一化 LS MSE。

    if nargin < 3
        noise_var = 1;
    end

    X = build_training_matrix(Omega, channel_len);
    Gram = X' * X;
    p = size(Gram, 1);
    Nt = size(Omega, 1);
    E = sum(abs(Omega(1, :)).^2);

    target = E * eye(p);
    metrics.X = X;
    metrics.Gram = Gram;
    metrics.energy_per_antenna = E;
    metrics.gram_error_fro = norm(Gram - target, 'fro') / max(1, norm(target, 'fro'));
    metrics.gram_error_max = max(abs(Gram(:) - target(:)));
    metrics.rank = rank(Gram, 1e-10);
    metrics.num_params = Nt * channel_len;

    if metrics.rank < p
        metrics.normalized_mse = Inf;
    else
        metrics.normalized_mse = real(noise_var * trace(inv(Gram)) / metrics.num_params);
    end

    metrics.lower_bound = noise_var / E;
end
