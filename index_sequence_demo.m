% 实现说明。
clear; clc;

mu = 3;  % 实现说明。
g_gen_mode = 1;  % 实现说明。

%% 验证或构造步骤
len_g = 2^mu;  % 实现说明。

% 实现说明。
if g_gen_mode == 1
    g = 0 : len_g - 1;  % 实现说明。
% 实现说明。
elseif g_gen_mode == 2
    % 实现说明。
    g = [0, 2, 4, 6, 1, 3, 5, 7];
else
    error('Invalid input');
end

%% 验证或构造步骤
disp('Output');
disp(['Output', num2str(mu), 'Output', num2str(len_g)]);
disp('Output');
disp(g);
