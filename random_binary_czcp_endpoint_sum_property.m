clear; clc; close all;


rng('shuffle');

N = 8;
Z = 4;

base_a = [1, 1, 1, -1, 1, 1, -1, 1];
base_b = [1, 1, 1, -1, -1, -1, 1, -1];

sign_a = 2 * randi([0, 1]) - 1;
sign_b = 2 * randi([0, 1]) - 1;
a = sign_a * base_a;
b = sign_b * base_b;

did_reverse = rand > 0.5;
if did_reverse
    a = fliplr(a);
    b = fliplr(b);
end

did_swap = rand > 0.5;
if did_swap
    tmp = a;
    a = b;
    b = tmp;
end

cond_even_length = (mod(N, 2) == 0);
cond_binary_unit_modulus = all(ismember(a, [-1, 1])) && all(ismember(b, [-1, 1])) && ...
    all(abs(a) == 1) && all(abs(b) == 1);

result_values = zeros(1, Z);
cond_p3 = true;
for i = 0:Z-1
    idx1 = i + 1;
    idx2 = N - i;
    sum_val = a(idx1) + a(idx2) + b(idx1) + b(idx2);
    result_values(i + 1) = sum_val;

    if abs(sum_val - 2) > 1e-10 && abs(sum_val + 2) > 1e-10
        cond_p3 = false;
    end
end

[is_czcp, czcp_results] = perfect_czcp_condition_check(a, b);
cond_czcp_width = (Z == N / 2);

disp('Random binary unit-modulus CZCP pair');
fprintf('N = %d, Z = %d\n', N, Z);
fprintf('Random signs: sign_a = %+d, sign_b = %+d\n', sign_a, sign_b);
fprintf('Reverse operation used: %d\n', did_reverse);
fprintf('Swap operation used: %d\n', did_swap);

disp('Sequence a:');
disp(a);
disp('Sequence b:');
disp(b);

fprintf('Even-length check: %d\n', cond_even_length);
fprintf('Binary unit-modulus check: %d\n', cond_binary_unit_modulus);
fprintf('CZCP width check Z = N/2: %d\n', cond_czcp_width);
fprintf('Perfect (8,4)-CZCP check: %d\n', is_czcp);
fprintf('Max C1 residual: %.2e\n', max(abs(czcp_results.C1_vals)));
fprintf('Max C2 residual: %.2e\n', max(abs(czcp_results.C2_vals)));

disp('P3 values a(i)+a(N-1-i)+b(i)+b(N-1-i), i = 0:Z-1:');
disp(result_values);

if cond_p3
    disp('P3 verification passed: every value is +2 or -2.');
else
    disp('P3 verification failed: at least one value is not +2 or -2.');
end
