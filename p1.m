clear; clc; close all;

N = 9;  % Implementation note.
Z = 3;  % Implementation note.
omega4 = exp(1i * 2 * pi / 4);  % Implementation note.

a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];

% Implementation note.
% Implementation note.
c = a / a(1);
d = b / b(1);

% Implementation note.
% Implementation note.
cond1 = true;
for i = 0:Z-1
    if abs(c(i+1) - d(i+1)) > 1e-10  % Implementation note.
        cond1 = false;
        break;
    end
end

% Implementation note.
cond2 = true;
for i = 0:Z-1
    idx = N - i;  % Implementation note.
    if abs(c(idx) + d(idx)) > 1e-10
        cond2 = false;
        break;
    end
end

% Implementation note.
disp('Output');
fprintf('Output: %d, %d\n', N, Z);
disp('Output');
disp([c(1:Z); d(1:Z)]);
disp('Output');
disp([c(N-Z+1:N); d(N-Z+1:N)]);

if cond1 && cond2
    disp('Output');
else
    disp('Output');
end
