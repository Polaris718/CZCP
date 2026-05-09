function T_minus_tau = cyclic_shift_left(x, tau)
    % 实现公式 T^{-τ}(x) 的循环左移操作
    % 输入：
    % x   - 原始N维向量（行/列均可，输出统一为列向量）
    % tau - 移位位数（非负整数，需满足 0 ≤ tau < length(x)）
    % 输出：
    % T_minus_tau - 循环左移后的N维列向量，对应公式 T^{-τ}(x)
    
    % 统一转为列向量
    x = x(:);
    N = length(x);
    
    % 合法性检查
    if tau < 0 || tau >= N
        error('移位位数tau必须满足 0 ≤ tau < %d（向量长度）', N);
    end
    
    % 移位0位直接返回
    if tau == 0
        T_minus_tau = x;
        return;
    end
    
    % 由 数学下标 到 MATLAB下标转换
    % 公式中 xτ 到 xN-1 对应 MATLAB 的 x(tau+1 : N)
    part1 = x(tau + 1 : N);
    % 公式中 x0 到 xτ-1 对应 MATLAB 的 x(1 : tau)
    part2 = x(1 : tau);
    
    % 拼接输出列向量
    T_minus_tau = [part1; part2];
end