clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

% 生成完美CZCP
fprintf('\n【步骤1：生成基础完美CZCP】\n');
q = 4;
mu = 4;
perm_vec = [4, 2, 3, 1];
w_k = [3, 2, 0, 1];
w = 0;
w_prime = 2;

[czcp_pair, N, Z] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime);

a_czcp = czcp_pair.a;
b_czcp = czcp_pair.b;
fprintf('基础CZCP参数：N=%d, Z=%d（完美CZCP）\n', N, Z);

% 构造CZCS
fprintf('\n【步骤2：构造CZCS】\n');
M = 4; % 4天线
try
    czcs_set = czcs_from_czcp(a_czcp, b_czcp, M);
catch ME
    error('调用czcs_from_czcp失败：%s', ME.message);
end

fprintf('生成CZCS参数：序列数M=%d, 序列长度N=%d, 零相关区Z=%d\n', M, N, Z);

% 验证CZCS
fprintf('\n【步骤3：CZCS条件验证】\n');
try
    [is_valid, results] = verify_czcs(czcs_set, Z);
catch ME
    error('调用verify_czcs失败：%s', ME.message);
end

if is_valid
    fprintf('CZCS验证通过，满足Definition 6的C1和C2条件\n');
else
    fprintf('CZCS验证失败\n');
end

% 输出结果详情
fprintf('\n【验证结果详情】\n');
if ~isempty(results.C1_vals)
    fprintf('C1条件：|τ|∈T1∪T2 时自相关和最大值：%.2e\n', max(abs(results.C1_vals)));
end
if ~isempty(results.C2_vals)
    fprintf('C2条件：|τ|∈T2 时循环互相关和最大值：%.2e\n', max(abs(results.C2_vals)));
end
