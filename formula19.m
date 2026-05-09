%% 规则：d前半段 = c，d后半段 = -c
clear; clc; close all;

%% 1. 定义参数
N = 8;          % 序列长度N（必须为偶数）
half_N = N/2;   

%% 2. 生成 模=1 的标准复数序列 c
c = exp(1i * linspace(0, 7*pi/4, N));  

%% 3. 按公式19构造序列d
d = zeros(1, N);
d(1 : half_N) = c(1 : half_N);        % 前半段：d = c
d(half_N+1 : N) = -c(half_N+1 : N);  % 后半段：d = -c

%% 4. 构造公式19最终矩阵
result_matrix = [c; d];

%% 5. 输出结果
disp('测试序列 c');
disp(c);

disp('构造序列 d');
disp(d);

disp(' 2×N 结果矩阵');
disp(result_matrix);

cond1 = isequal(d(1:half_N), c(1:half_N));
cond2 = isequal(d(half_N+1:end), -c(half_N+1:end));
cond3 = all(abs(abs(c)-1) < 1e-15);

fprintf('d 前半段 == c 前半段？        ');
if cond1, fprintf('是\n'); else fprintf('否\n'); end

fprintf('d 后半段 == -c 后半段？       ');
if cond2, fprintf('是\n'); else fprintf('否\n'); end