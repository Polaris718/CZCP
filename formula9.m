%% Verification or construction step
%% Verification or construction step
clear; clc;

%% Verification or construction step
% Implementation note.
kappa_set = [
    0 0 0;
    1 0 0;
    0 1 0;
    1 1 0;
    0 0 1;
    1 0 1;
    0 1 1;
    1 1 1;
];
disp('Output');
disp(kappa_set);

%% Verification or construction step
one_vec  = [1,1,1,1,1,1,1,1];  % Implementation note.
x1_vec   = [0,1,0,1,0,1,0,1];  % Implementation note.
x3_vec   = [0,0,0,0,1,1,1,1];  % Implementation note.

%% Verification or construction step
calc_vec = 2 * x1_vec .* x3_vec + one_vec;

%% Verification or construction step
disp('Output');
disp(one_vec);
disp('Output');
disp(x1_vec);
disp('Output');
disp(x3_vec);
disp('Output');
disp(calc_vec);
