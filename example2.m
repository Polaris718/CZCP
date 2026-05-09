clear; clc; close all;

Nt = 4;          % 发射天线数
M_SM = 8;        % 调制阶数（8-PSK）
K = 4;           % 每个SC-SM块包含的SM符号数
omega8 = exp(1i * 2 * pi / 8);  % 8次单位根 ω8 = exp(j2π/8)

% 20比特输入（分成4组，每组5比特：2比特空间+3比特星座）
input_bits = [1 0 0 1 0;   % 第1个时隙：b(1)=[10 010]
              1 1 0 1 1;   % 第2个时隙：b(2)=[11 011]
              0 1 1 1 0;   % 第3个时隙：b(3)=[01 110]
              0 0 1 0 0];  % 第4个时隙：b(4)=[00 100]

% 预分配SM符号矩阵（Nt行 × K列，每列对应1个时隙的SM符号向量）
D = zeros(Nt, K);

for k = 1:K
    % （1）拆分比特：前2比特为空间比特，后3比特为星座比特
    space_bits = input_bits(k, 1:2);   % 空间比特 b1(k)
    const_bits = input_bits(k, 3:5);    % 星座比特 b2(k)
    
    % （2）空间比特 → 天线索引（自然映射，二进制转十进制，MATLAB索引从1开始）
    n_k = bi2de(space_bits, 'left-msb') + 1;  % 激活的天线序号 n(k)
    
    % （3）星座比特 → 8-PSK星座符号（自然映射，相位为 2π×十进制值/8）
    const_idx = bi2de(const_bits, 'left-msb'); % 星座符号的十进制索引
    S_k = omega8^const_idx;                     % 复值星座符号 S_{n(k)}
    
    % （4）生成SM符号向量 d_k = S_{n(k)} * e_{n(k)}（对应公式11）
    d_k = zeros(Nt, 1);
    d_k(n_k) = S_k;  % 仅激活天线位置有非零值
    
    % （5）存入SM符号矩阵
    D(:, k) = d_k;
end

disp('================== SM符号映射结果 ==================');
disp('输入比特流（每行对应1个时隙，前2位空间比特，后3位星座比特）：');
disp(input_bits);

disp(' ');
disp('8-PSK星座符号映射表（十进制索引 → 复数值）：');
for m = 0:M_SM-1
    fprintf('索引%d：ω8^%d = %.4f + %.4fi\n', m, m, real(omega8^m), imag(omega8^m));
end

disp(' ');
disp('SC-SM块的稀疏矩阵 [d1, d2, d3, d4]（对应公式12）：');
disp(D);

% （可选）可视化矩阵的稀疏性
figure;
spy(D, 10);  %  spy函数显示非零元素位置
title('示例2：SM符号矩阵的稀疏性');
xlabel('时隙索引');
ylabel('发射天线索引');