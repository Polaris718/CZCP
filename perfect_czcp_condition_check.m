function [is_perfect, results] = perfect_czcp_condition_check(a, b)
    N = length(a);
    Z = N/2;  % CZCP 参数。
    [tau_all, rho_a] = aperiodic_autocorr(a);
    [~, rho_b] = aperiodic_autocorr(b);
    [~, rho_ab] = aperiodic_crosscorr(a, b);
    [~, rho_ba] = aperiodic_crosscorr(b, a);

    T1 = 1:Z;
    T2 = (N-Z):(N-1);
    idx_C1 = ismember(abs(tau_all), [T1, T2]);
    idx_C2 = ismember(abs(tau_all), T2);

    C1_vals = rho_a(idx_C1) + rho_b(idx_C1);
    C2_vals = rho_ab(idx_C2) + rho_ba(idx_C2);

    is_valid_C1 = all(abs(C1_vals) < 1e-10);
    is_valid_C2 = all(abs(C2_vals) < 1e-10);

    is_perfect = is_valid_C1 && is_valid_C2;
    results.C1_vals = C1_vals;
    results.C2_vals = C2_vals;
    results.tau_C1 = tau_all(idx_C1);
    results.tau_C2 = tau_all(idx_C2);
    results.rho_a = rho_a;
    results.rho_b = rho_b;
    results.rho_ab = rho_ab;
    results.rho_ba = rho_ba;
    results.tau_all = tau_all;
end
