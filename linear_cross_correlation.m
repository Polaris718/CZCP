function rho = linear_cross_correlation(a, b, tau)
    % 公式（3）计算线性互相关 ρ(a,b)(τ)
    % 输入：
    % a   - N维列向量（行向量自动转置）
    % b   - N维列向量（行向量自动转置）
    % tau - 延迟值（0 ≤ tau < N，匹配公式3场景）
    % 输出：rho  - 线性互相关值
    
    a = a(:);  % 统一转为列向量
    b = b(:);
    N = length(a);
    
    % 合法性检查
    if length(b) ~= N
        error('向量a和b必须同维度（当前a长度=%d，b长度=%d）', N, length(b));
    end
    if tau < 0 || tau >= N
        error('延迟tau必须满足 0 ≤ tau < %d', N);
    end
    
    rho = 0;
    % 线性互相关：仅n+τ < N时有效（超出部分为0，无循环）
    for n = 0 : N-1-tau
        a_idx = n + 1;       % 0基下标→MATLAB 1基下标
        b_idx = n + tau + 1; % b_{n+τ}的1基下标
        rho = rho + a(a_idx) * conj(b(b_idx));
    end
end