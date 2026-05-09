clear; clc; close all;

N = 5;
% 序列a：所有元素模为1（4次单位根）
a = [1; 1i; -1; -1i; 1];
% 序列b：所有元素模为1（8次单位根）
b = [exp(1i*pi/4); exp(1i*3*pi/4); exp(1i*5*pi/4); exp(1i*7*pi/4); exp(1i*pi/4)];
% 测试延迟τ
tau = 2;

% 内积形式（公式(2)的内积定义）
phi_inner = cyclic_cross_correlation(a, b, tau, 'inner');
% 求和形式（公式(2)的逐元素求和定义）
phi_sum = cyclic_cross_correlation(a, b, tau, 'sum');


disp('================== 循环互相关计算结果 ==================');
disp(['内积形式计算结果：', num2str(phi_inner)]);
disp(['求和形式计算结果：', num2str(phi_sum)]);
disp(['两种方法的绝对误差：', num2str(abs(phi_inner - phi_sum))]);

% 一致性验证
if abs(phi_inner - phi_sum) < 1e-10
    disp('✅ 验证通过：两种方法计算结果完全一致（数值误差范围内）');
else
    disp('❌ 验证失败：两种方法结果不一致');
end