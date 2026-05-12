% Implementation note.
clear; clc;

mu = 3;  % Implementation note.
g_gen_mode = 1;  % Implementation note.

%% Verification or construction step
len_g = 2^mu;  % Implementation note.

% Implementation note.
if g_gen_mode == 1
    g = 0 : len_g - 1;  % Implementation note.
% Implementation note.
elseif g_gen_mode == 2
    % Implementation note.
    g = [0, 2, 4, 6, 1, 3, 5, 7];
else
    error('Invalid input');
end

%% Verification or construction step
disp('Output');
disp(['Output', num2str(mu), 'Output', num2str(len_g)]);
disp('Output');
disp(g);
