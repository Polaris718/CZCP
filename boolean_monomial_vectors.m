%% 验证或构造步骤
%% 验证或构造步骤
clear; clc;

%% 验证或构造步骤
% 实现说明。
kappa_set = [
    0 0 0;
    1 0 0;
    0 1 0;
    1 1 0;
    0 0 1;
    1 0 1;
    0 1 1;
    1 1 1;
];
disp('Output');
disp(kappa_set);

%% 验证或构造步骤
one_vec  = [1,1,1,1,1,1,1,1];  % 实现说明。
x1_vec   = [0,1,0,1,0,1,0,1];  % 实现说明。
x3_vec   = [0,0,0,0,1,1,1,1];  % 实现说明。

%% 验证或构造步骤
calc_vec = 2 * x1_vec .* x3_vec + one_vec;

%% 验证或构造步骤
disp('Output');
disp(one_vec);
disp('Output');
disp(x1_vec);
disp('Output');
disp(x3_vec);
disp('Output');
disp(calc_vec);
