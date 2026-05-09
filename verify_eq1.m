N = 8;  % 序列长度（选论文常用的2的幂次）
% 生成方法：随机相位 + exp(1i*相位)，保证模值为1
a = exp(1i * 2 * pi * rand(N, 1));  % 随机单位模序列a
b = exp(1i * 2 * pi * rand(N, 1));  % 随机单位模序列b

% ---------- 3. 显示序列信息 ----------
disp('=== 测试序列信息 ===');
fprintf('序列长度 N = %d\n', N);
disp('随机单位模序列 a（元素模值≈1）：');
for i = 1:N
    fprintf('a(%d) = %.4f + %.4fi  (|a|=%.4f)\n', i-1, real(a(i)), imag(a(i)), abs(a(i)));
end
disp(' ');
disp('随机单位模序列 b（元素模值≈1）：');
for i = 1:N
    fprintf('b(%d) = %.4f + %.4fi  (|b|=%.4f)\n', i-1, real(b(i)), imag(b(i)), abs(b(i)));
end

% ---------- 4. 测试不同延迟τ的情况 ----------
test_taus = [-8, -5, -2, 0, 1, 3, 7, 8]; % 覆盖所有分段
disp(' ');
disp('=== 公式(1)非周期互相关验证结果 ===');
for tau = test_taus
    rho = full_linear_cross_correlation(a, b, tau);
    
    % 标注延迟类型
    if abs(tau) >= N
        type = '（超出范围 |τ|≥N）';
    elseif tau > 0
        type = '（正延迟 0≤τ≤N-1）';
    elseif tau < 0
        type = '（负延迟 -(N-1)≤τ≤-1）';
    else
        type = '（零延迟 τ=0）';
    end
    
    % 显示复数结果（实部+虚部）
    fprintf('τ=%2d %s：ρ(a,b)(τ) = %.6f %+.6fi\n', ...
        tau, type, real(rho), imag(rho));
end