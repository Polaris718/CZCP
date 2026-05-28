omega4 = exp(1i * 2 * pi / 4);
a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];
N = 9; Z = 3;

T1 = 1:Z;                  % T1 = {1,2,3}
T2 = (N-Z):(N-1);          % T2 = {6,7,8}
tau_C1 = unique([T1, T2]);
tau_C2 = T2;

[tau_all, rho_a] = aperiodic_autocorr(a);
[~, rho_b] = aperiodic_autocorr(b);
[~, rho_ab] = aperiodic_crosscorr(a, b);
[~, rho_ba] = aperiodic_crosscorr(b, a);

AAC_sum = rho_a + rho_b;
ACC_sum = rho_ab + rho_ba;

disp('Output');
fprintf('Output: %s\n', num2str(tau_C1));
C1_pass = true;
for t = tau_C1
    idx = find(abs(tau_all) == t, 1);
    val = abs(AAC_sum(idx));
    if val < 1e-10
        fprintf('Output: %d, %.8f\n', t, val);
    else
        fprintf('Output: %d, %.8f\n', t, val);
        C1_pass = false;
    end
end

disp('Output\n');
fprintf('Output: %s\n', num2str(tau_C2));
C2_pass = true;
for t = tau_C2
    idx = find(abs(tau_all) == t, 1);
    val = abs(ACC_sum(idx));
    if val < 1e-10
        fprintf('Output: %d, %.8f\n', t, val);
    else
        fprintf('Output: %d, %.8f\n', t, val);
        C2_pass = false;
    end
end

disp('Output\n');
if C1_pass && C2_pass
    fprintf('Output: %d, %d\n', N, Z);
else
    fprintf('Output: %d, %d\n', N, Z);
end
