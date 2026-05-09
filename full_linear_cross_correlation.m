function rho = full_linear_cross_correlation(a, b, tau)
    % 公式(1)：完整线性互相关 ρ(a,b)(τ)
    % 输入：
    %   a    - N维列向量（行向量自动转置）
    %   b    - N维列向量（行向量自动转置）
    %   tau  - 延迟值（任意整数，支持正/负/超出范围）
    % 输出：
    %   rho  - 线性互相关值（按公式(1)分段计算）
    
    % 统一转为列向量，确保维度一致
    a = a(:);
    b = b(:);
    N = length(a);
    
    % 合法性检查：a和b维度必须相同
    if length(b) ~= N
        error('向量a和b必须同维度（当前a长度=%d，b长度=%d）', N, length(b));
    end
    
    % 分段计算（严格匹配公式(1)）
    if abs(tau) >= N
        % 情况3：|τ|≥N，互相关值为0
        rho = 0;
    elseif tau >= 0 && tau <= N-1
        % 情况1：0 ≤ τ ≤ N-1（正延迟）
        rho = 0;
        for n = 0 : N - tau - 1
            a_idx = n + 1;       % 0基→1基下标
            b_idx = n + tau + 1; % b_{n+τ}的1基下标
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    elseif tau >= -(N-1) && tau <= -1
        % 情况2：-(N-1) ≤ τ ≤ -1（负延迟）
        rho = 0;
        for n = 0 : N + tau - 1
            a_idx = n - tau + 1; % a_{n-τ}的1基下标（τ为负，n-τ = n+|τ|）
            b_idx = n + 1;       % b_n的1基下标
            rho = rho + a(a_idx) * conj(b(b_idx));
        end
    else
        % 理论上不会触发（已覆盖所有情况），仅做容错
        rho = 0;
    end
end