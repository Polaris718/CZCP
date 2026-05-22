function [czcp_pair, N, Z] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime)
%Q_RAY_CZCP 由GBF构造生成完美q元CZCP。
%   这里实现论文示例6使用的q元GBF构造。

    if mod(q, 2) ~= 0
        error('q must be even.');
    end
    if length(perm_vec) ~= mu
        error('perm_vec length must equal mu.');
    end
    if perm_vec(1) ~= mu
        error('perm_vec(1) must equal mu.');
    end
    if length(w_k) ~= mu
        error('w_k length must equal mu.');
    end
    if ~ismember(mod(w_prime, q), [0, q / 2])
        error('w_prime must be congruent to 0 or q/2 modulo q.');
    end

    N = 2^mu;
    Z = N / 2;
    kappa_list = 0:N-1;
    g_kappa = zeros(1, N);
    g_prime_kappa = zeros(1, N);

    for idx = 1:N
        kappa = kappa_list(idx);
        kappa_bits = bitget(kappa, 1:mu);

        quad_term = 0;
        for k = 1:mu-1
            quad_term = quad_term + ...
                kappa_bits(perm_vec(k)) * kappa_bits(perm_vec(k + 1));
        end
        quad_term = (q / 2) * quad_term;

        linear_term = sum(w_k .* kappa_bits);
        g_kappa(idx) = mod(quad_term + linear_term + w, q);

        x_pi1 = kappa_bits(perm_vec(1));
        g_prime_kappa(idx) = mod(g_kappa(idx) + (q / 2) * x_pi1 + w_prime, q);
    end

    czcp_pair.a = exp(1i * 2 * pi * g_kappa / q);
    czcp_pair.b = exp(1i * 2 * pi * g_prime_kappa / q);
end
