function T_tau = cyclic_shift(x, tau)
    % 实现公式 T^τ(x) 的循环移位操作
    % 输入：
    % x   - 原始N维向量（行/列均可，输出统一为列向量）
    % tau - 移位位数（非负整数，需满足 0 ≤ tau < length(x)）
    % 输出：
    % T_tau - 循环移位后的N维列向量，对应公式 T^τ(x)
    
    % 统一将输入转为列向量（匹配公式的列向量输出）
    x = x(:);
    % 获取向量长度N
    N = length(x);
    
    % 输入合法性检查（避免无效移位）
    if tau < 0 || tau >= N
        error('移位位数tau必须满足 0 ≤ tau < %d（向量长度）', N);
    end
    
    % 移位0位时直接返回原向量
    if tau == 0
        T_tau = x;
        return;
    end
    
    % 数学下标 → MATLAB下标转换（核心步骤）
    last_tau_elements = x(N - tau + 1 : N);  % 对应公式中最后τ个元素
    first_N_tau_elements = x(1 : N - tau);   % 对应公式中前N-τ个元素
    
    % 拼接并输出列向量（与公式的转置操作一致）
    T_tau = [last_tau_elements; first_N_tau_elements];
end