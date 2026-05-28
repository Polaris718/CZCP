clearvars; if ~isappdata(0, 'KEEP_PAPER_FIGURES') || ~getappdata(0, 'KEEP_PAPER_FIGURES'), close all; end; clc;

fprintf('Output\n');
q = 4;
mu = 4;
perm_vec = [4, 2, 3, 1];
w_k = [3, 2, 0, 1];
w = 0;
w_prime = 2;

[czcp_pair, N, Z] = q_ray_czcp(q, mu, perm_vec, w_k, w, w_prime);

a_czcp = czcp_pair.a;
b_czcp = czcp_pair.b;
fprintf('Output: %d, %d\n', N, Z);

fprintf('Output\n');
M = 4;
try
    czcs_set = czcs_from_czcp(a_czcp, b_czcp, M);
catch ME
    error('Invalid input: %s', ME.message);
end

fprintf('Output: %d, %d, %d\n', M, N, Z);

fprintf('Output\n');
try
    [is_valid, results] = czcs_condition_check(czcs_set, Z);
catch ME
    error('Invalid input: %s', ME.message);
end

if is_valid
    fprintf('Output\n');
else
    fprintf('Output\n');
end

fprintf('Output\n');
if ~isempty(results.C1_vals)
    fprintf('Output: %.2e\n', max(abs(results.C1_vals)));
end
if ~isempty(results.C2_vals)
    fprintf('Output: %.2e\n', max(abs(results.C2_vals)));
end
