clear;
clc;

%% 枚举二进制输入
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
disp('Binary input vectors:');
disp(kappa_set);

%% 构造单项式向量
one_vec = [1, 1, 1, 1, 1, 1, 1, 1];
x1_vec = [0, 1, 0, 1, 0, 1, 0, 1];
x3_vec = [0, 0, 0, 0, 1, 1, 1, 1];

%% 计算布尔单项式表达式
calc_vec = 2 * x1_vec .* x3_vec + one_vec;

disp('Constant term:');
disp(one_vec);
disp('x1 term:');
disp(x1_vec);
disp('x3 term:');
disp(x3_vec);
disp('2*x1*x3 + 1:');
disp(calc_vec);
