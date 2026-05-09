function phi = cyclic_cross_correlation(a, b, tau, method)
    % 公式（2） 计算循环互相关 φ(a,b)(τ)
    % 输入：
    %   a      - N维列向量（行向量也可，会自动转置）
    %   b      - N维列向量（行向量也可，会自动转置）
    %   tau    - 延迟值（0 ≤ tau < N）
    %   method - 计算方式：'sum'（求和形式）/'inner'（内积形式，默认）
    % 输出：
    %   phi    - 循环互相关值
    
    % 默认参数
    if nargin < 4
        method = 'inner';
    end
    
    % 统一转为列向量，确保维度一致
    a = a(:);
    b = b(:);
    N = length(a);
    
    % 合法性检查
    if length(b) ~= N
        error('向量a和b必须同维度（当前a长度=%d，b长度=%d）', N, length(b));
    end
    if tau < 0 || tau >= N
        error('延迟tau必须满足 0 ≤ tau < %d', N);
    end
    
    % 方法1：内积形式（简洁，利用之前的循环移位）
    if strcmp(method, 'inner')
        b_shift = cyclic_shift_left(b, tau);  % T^{-τ}(b)
        phi = a.' * conj(b_shift);            % 内积：<a, T^{-τ}(b)> = a^H * T^{-τ}(b)
    % 方法2：求和形式（直观，逐元素计算）
    elseif strcmp(method, 'sum')
        phi = 0;
        for n = 0 : N-1
            % 计算循环索引：floor(n+tau) mod N（MATLAB下标+1）
            idx = mod(n + tau, N) + 1;  % 0基→1基转换
            phi = phi + a(n+1) * conj(b(idx));  % a_n * b^*_{(n+τ) mod N}
        end
    else
        error('method参数只能是''inner''或''sum''');
    end
end