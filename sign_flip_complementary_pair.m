clear;
clc;
close all;

N = 8;
half_N = N / 2;

c = exp(1i * linspace(0, 7 * pi / 4, N));

d = zeros(1, N);
d(1:half_N) = c(1:half_N);
d(half_N + 1:N) = -c(half_N + 1:N);

result_matrix = [c; d];

disp('Sequence c:');
disp(c);

disp('Sequence d:');
disp(d);

disp('Complementary pair matrix:');
disp(result_matrix);

cond1 = isequal(d(1:half_N), c(1:half_N));
cond2 = isequal(d(half_N + 1:end), -c(half_N + 1:end));
cond3 = all(abs(abs(c) - 1) < 1e-15);

fprintf('First half unchanged: %d\n', cond1);
fprintf('Second half sign-flipped: %d\n', cond2);
fprintf('Sequence c has unit magnitude: %d\n', cond3);
