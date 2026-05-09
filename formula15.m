omega4 = exp(1i * 2 * pi / 4);
a = omega4.^[0, 1, 1, 2, 0, 2, 1, 1, 3];  % 公式(14)
b = omega4.^[0, 1, 1, 0, 1, 0, 3, 3, 1];  % 公式(14)
N = 9; Z = 3;

% ---------- 步骤2：定义定义4的时延集合 ----------
T1 = 1:Z;                  % T1 = {1,2,3}
T2 = (N-Z):(N-1);          % T2 = {6,7,8}
tau_C1 = unique([T1, T2]); % C1的时延：|τ| ∈ T1∪T2
tau_C2 = T2;                % C2的时延：|τ| ∈ T2

% ---------- 步骤3：计算相关和 ----------
[tau_all, rho_a] = aperiodic_autocorr(a);
[~, rho_b] = aperiodic_autocorr(b);
[~, rho_ab] = aperiodic_crosscorr(a, b);
[~, rho_ba] = aperiodic_crosscorr(b, a);

AAC_sum = rho_a + rho_b;   % C1左边：ρ(a)(τ)+ρ(b)(τ)
ACC_sum = rho_ab + rho_ba; % C2左边：ρ(a,b)(τ)+ρ(b,a)(τ)

% ---------- 步骤4：验证条件C1 ----------
disp('================== 证明条件C1 ==================');
fprintf('验证 |τ| ∈ T1∪T2 = {%s} 时，|ρ(a)(τ)+ρ(b)(τ)| ≈ 0：\n', num2str(tau_C1));
C1_pass = true;
for t = tau_C1
    idx = find(abs(tau_all) == t, 1);
    val = abs(AAC_sum(idx));
    if val < 1e-10
        fprintf('  |τ| = %d：模值 = %.8f ≈ 0 ✅\n', t, val);
    else
        fprintf('  |τ| = %d：模值 = %.8f ≠ 0 ❌\n', t, val);
        C1_pass = false;
    end
end

% ---------- 步骤5：验证条件C2 ----------
disp('\n================== 证明条件C2 ==================');
fprintf('验证 |τ| ∈ T2 = {%s} 时，|ρ(a,b)(τ)+ρ(b,a)(τ)| ≈ 0：\n', num2str(tau_C2));
C2_pass = true;
for t = tau_C2
    idx = find(abs(tau_all) == t, 1);
    val = abs(ACC_sum(idx));
    if val < 1e-10
        fprintf('  |τ| = %d：模值 = %.8f ≈ 0 ✅\n', t, val);
    else
        fprintf('  |τ| = %d：模值 = %.8f ≠ 0 ❌\n', t, val);
        C2_pass = false;
    end
end

% ---------- 步骤6：最终结论 ----------
disp('\n================== 最终证明结论 ==================');
if C1_pass && C2_pass
    fprintf('✅ 序列(a,b)满足定义4的所有条件，是(%d,%d)-CZCP。\n', N, Z);
else
    fprintf('❌ 序列(a,b)不满足定义4的条件，不是(%d,%d)-CZCP。\n', N, Z);
end