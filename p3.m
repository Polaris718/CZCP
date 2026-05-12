clear; clc; close all;

N = 4;  % Implementation note.
Z = 2;  % Implementation note.
a = [1, 1, 1, 1];  % Implementation note.
b = [1, 1, -1, -1];  % Implementation note.

% Implementation note.
% Implementation note.
cond1 = (mod(N, 2) == 0);

% Implementation note.
cond2 = true;
result_values = zeros(1, Z);  % Implementation note.
for i = 0:Z-1
    % Implementation note.
    idx1 = i + 1;  % Implementation note.
    idx2 = N - i;  % Implementation note.
    sum_val = a(idx1) + a(idx2) + b(idx1) + b(idx2);
    result_values(i+1) = sum_val;
    % Implementation note.
    if abs(sum_val - 2) > 1e-10 && abs(sum_val + 2) > 1e-10
        cond2 = false;
        break;
    end
end


disp('Output');
fprintf('Output: %d, %d\n', N, Z);
disp('Output'); disp(a);
disp('Output'); disp(b);
fprintf('Output');
if cond1; disp('Output'); else; disp('Output'); end
fprintf('Output'); disp(result_values);
if cond2
    disp('Output');
else
    disp('Output');
end
