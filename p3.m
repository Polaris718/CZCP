clear; clc; close all;

N = 4;          % 序列长度（应为偶数）
Z = 2;          % 零相关区宽度
a = [1, 1, 1, 1];   % 论文表I中的序列a
b = [1, 1, -1, -1]; % 论文表I中的序列b

% 验证性质P3的两个条件
% 条件1：序列长度N为偶数
cond1 = (mod(N, 2) == 0);

% 条件2：对i=0到Z-1，a_i + a_{N-1-i} + b_i + b_{N-1-i} = ±2
cond2 = true;
result_values = zeros(1, Z); % 存储计算结果
for i = 0:Z-1
    % MATLAB索引从1开始，论文i对应MATLAB i+1
    idx1 = i + 1;          % i的索引
    idx2 = N - i;          % N-1-i的索引（N-1-i+1 = N-i）
    sum_val = a(idx1) + a(idx2) + b(idx1) + b(idx2);
    result_values(i+1) = sum_val;
    % 检查是否为±2
    if abs(sum_val - 2) > 1e-10 && abs(sum_val + 2) > 1e-10
        cond2 = false;
        break;
    end
end


disp('================== 性质P3验证结果 ==================');
fprintf('序列参数：N = %d, Z = %d\n', N, Z);
disp('二元序列 a：'); disp(a);
disp('二元序列 b：'); disp(b);
fprintf('条件1（N为偶数）：');
if cond1; disp('满足'); else; disp('不满足'); end
fprintf('条件2（和为±2）的计算结果：'); disp(result_values);
if cond2
    disp('✅ 验证通过：P3的两个条件均满足');
else
    disp('❌ 验证失败：条件不满足');
end