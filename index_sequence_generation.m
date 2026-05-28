clear;
clc;

mu = 3;
g_gen_mode = 1;

%% 生成指数序列
len_g = 2^mu;

if g_gen_mode == 1
    g = 0:len_g - 1;
elseif g_gen_mode == 2
    g = [0, 2, 4, 6, 1, 3, 5, 7];
else
    error('Invalid input');
end

%% 显示结果
disp(['mu = ', num2str(mu), ', length = ', num2str(len_g)]);
disp('Index sequence:');
disp(g);
