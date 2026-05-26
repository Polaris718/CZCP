%% 验证或构造步骤
clear; clc; close all;

%% 验证或构造步骤
N = 8;  % 实现说明。
half_N = N/2;   

%% 验证或构造步骤
c = exp(1i * linspace(0, 7*pi/4, N));  

%% 验证或构造步骤
d = zeros(1, N);
d(1 : half_N) = c(1 : half_N);  % 实现说明。
d(half_N+1 : N) = -c(half_N+1 : N);  % 实现说明。

%% 验证或构造步骤
result_matrix = [c; d];

%% 验证或构造步骤
disp('Output');
disp(c);

disp('Output');
disp(d);

disp('Output');
disp(result_matrix);

cond1 = isequal(d(1:half_N), c(1:half_N));
cond2 = isequal(d(half_N+1:end), -c(half_N+1:end));
cond3 = all(abs(abs(c)-1) < 1e-15);

fprintf('Output');
if cond1, fprintf('Output\n'); else fprintf('Output\n'); end

fprintf('Output');
if cond2, fprintf('Output\n'); else fprintf('Output\n'); end
