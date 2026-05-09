function rho = linear_autocorrelation(x, tau)
    % 公式（4） 计算向量x的线性自相关 ρ(x)(τ)
    % 输入：
    % x    - N维列向量（行向量自动转置）
    % tau  - 延迟值（0 ≤ tau < N）
    % 输出：rho  - 线性自相关值（τ=0时为总能量，τ≠0时为延迟相关值）
    
    x = x(:);  % 统一转为列向量
    N = length(x);
    
    % 合法性检查
    if tau < 0 || tau >= N
        error('延迟tau必须满足 0 ≤ tau < %d', N);
    end
    
    % 线性自相关：仅n+τ < N时求和（超出部分为0）
    rho = 0;
    for n = 0 : N-1-tau
        x_n = x(n+1);          % x_n（0基→1基）
        x_n_tau = x(n+tau+1);  % x_{n+τ}（0基→1基）
        rho = rho + x_n * conj(x_n_tau);
    end
end