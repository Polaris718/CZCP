%% Verification or construction step
clear; clc; close all;

%% Verification or construction step
N = 8;  % Implementation note.
half_N = N/2;   

%% Verification or construction step
c = exp(1i * linspace(0, 7*pi/4, N));  

%% Verification or construction step
d = zeros(1, N);
d(1 : half_N) = c(1 : half_N);  % Implementation note.
d(half_N+1 : N) = -c(half_N+1 : N);  % Implementation note.

%% Verification or construction step
result_matrix = [c; d];

%% Verification or construction step
disp('Output');
disp(c);

disp('Output');
disp(d);

disp('Output');
disp(result_matrix);

cond1 = isequal(d(1:half_N), c(1:half_N));
cond2 = isequal(d(half_N+1:end), -c(half_N+1:end));
cond3 = all(abs(abs(c)-1) < 1e-15);

fprintf('Output');
if cond1, fprintf('Output\n'); else fprintf('Output\n'); end

fprintf('Output');
if cond2, fprintf('Output\n'); else fprintf('Output\n'); end
