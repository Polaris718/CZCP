clear;
clc;
close all;

N = 9;
Z = 3;
omega4 = exp(1i * 2 * pi / 4);

% 长度 9 的四相 CZCP 示例序列对。
a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];

% 用首元素归一化两条序列。
c = a / a(1);
d = b / b(1);

% 边界条件：前 Z 个元素应相等。
cond1 = true;
for i = 0:Z-1
    if abs(c(i + 1) - d(i + 1)) > 1e-10
        cond1 = false;
        break;
    end
end

% 边界条件：后 Z 个元素之和应为零。
cond2 = true;
for i = 0:Z-1
    idx = N - i;
    if abs(c(idx) + d(idx)) > 1e-10
        cond2 = false;
        break;
    end
end

fprintf('N = %d, Z = %d\n', N, Z);
disp('First Z entries:');
disp([c(1:Z); d(1:Z)]);
disp('Last Z entries:');
disp([c(N-Z+1:N); d(N-Z+1:N)]);

if cond1 && cond2
    disp('Boundary conditions passed.');
else
    disp('Boundary conditions failed.');
end
