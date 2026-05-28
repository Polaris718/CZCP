clear;
clc;
close all;

N = 9;
Z = 3;
omega4 = exp(1i * 2 * pi / 4);

% Example length-9 quaternary CZCP pair.
a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];

% Normalize both sequences by the first element.
c = a / a(1);
d = b / b(1);

% Boundary condition: the first Z entries should be equal.
cond1 = true;
for i = 0:Z-1
    if abs(c(i + 1) - d(i + 1)) > 1e-10
        cond1 = false;
        break;
    end
end

% Boundary condition: the last Z entries should sum to zero.
cond2 = true;
for i = 0:Z-1
    idx = N - i;
    if abs(c(idx) + d(idx)) > 1e-10
        cond2 = false;
        break;
    end
end

fprintf('N = %d, Z = %d\n', N, Z);
disp('First Z entries:');
disp([c(1:Z); d(1:Z)]);
disp('Last Z entries:');
disp([c(N-Z+1:N); d(N-Z+1:N)]);

if cond1 && cond2
    disp('Boundary conditions passed.');
else
    disp('Boundary conditions failed.');
end
