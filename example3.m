% 验证：等价CZCP 
clear; clc; close all;

N = 9;          % 序列长度
Z = 3;          % 零相关区宽度
omega4 = exp(1i * 2 * pi / 4);  % 4次单位根

% 原始序列a和b
a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];

% 生成等价CZCP (c,d) 
% 归一化：c = a / a_0，d = b / b_0（MATLAB索引从1开始，a(1)对应a_0）
c = a / a(1);
d = b / b(1);

% 验证性质P1的两个条件 
% 条件1：前Z个元素 c_i = d_i（i=0到Z-1，对应MATLAB索引1到Z）
cond1 = true;
for i = 0:Z-1
    if abs(c(i+1) - d(i+1)) > 1e-10  % 忽略浮点误差
        cond1 = false;
        break;
    end
end

% 条件2：后Z个元素 c_{N-1-i} = -d_{N-1-i}（i=0到Z-1，对应MATLAB索引N到N-Z+1）
cond2 = true;
for i = 0:Z-1
    idx = N - i;  % MATLAB索引：N-1-i+1 = N-i
    if abs(c(idx) + d(idx)) > 1e-10
        cond2 = false;
        break;
    end
end

% ---------- 4. 结果显示 ----------
disp('================== 性质P1验证结果 ==================');
fprintf('序列参数：N = %d, Z = %d\n', N, Z);
disp('等价序列 (c,d) 的前Z个元素：');
disp([c(1:Z); d(1:Z)]);
disp('等价序列 (c,d) 的后Z个元素：');
disp([c(N-Z+1:N); d(N-Z+1:N)]);

if cond1 && cond2
    disp('✅ 验证通过：P1的两个条件均满足');
else
    disp('❌ 验证失败：条件不满足');
end