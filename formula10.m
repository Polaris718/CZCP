%% Verification or construction step
mu      = 4;
q       = 4;
x       = [1, 0, 1, 0];  % Implementation note.
pi_vec  = [1, 2, 3, 4];  % Implementation note.
w       = [1, 1, 1, 1];  % Implementation note.
w_const = 0;  % Implementation note.

%% Verification or construction step
% Implementation note.
sum1 = 0;
for k = 1:mu-1
    sum1 = sum1 + x(pi_vec(k)) * x(pi_vec(k+1));
end
term1 = (q / 2) * sum1;

% Implementation note.
term2 = sum(w .* x);

% Implementation note.
g_x = term1 + term2 + w_const;

%% Verification or construction step
disp('Output');
disp(['Output', num2str(term1)]);
disp(['Output', num2str(term2)]);
disp(['Output', num2str(w_const)]);
disp(['------------------']);
disp(['Output', num2str(g_x)]);
