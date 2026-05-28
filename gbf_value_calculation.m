%% GBF Value Calculation
mu = 4;
q = 4;
x = [1, 0, 1, 0];
pi_vec = [1, 2, 3, 4];
w = [1, 1, 1, 1];
w_const = 0;

%% Quadratic and Linear Terms
sum1 = 0;
for k = 1:mu-1
    sum1 = sum1 + x(pi_vec(k)) * x(pi_vec(k + 1));
end
term1 = (q / 2) * sum1;
term2 = sum(w .* x);
g_x = term1 + term2 + w_const;

%% Display
disp('Quadratic term:');
disp(term1);
disp('Linear term:');
disp(term2);
disp('Constant term:');
disp(w_const);
disp('------------------');
disp('GBF value:');
disp(g_x);
