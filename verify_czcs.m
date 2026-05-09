%% CZCS条件验证
function [is_valid, results] = verify_czcs(czcs_set, Z)
    % 输入：
    %   czcs_set - CZCS序列集，czcs_set(m).seq 为第m条序列
    %   Z        - 零相关区宽度
    % 输出：
    %   is_valid - 布尔值，是否满足CZCS条件
    %   results  - 验证结果详情

    % 强制初始化输出参数
    is_valid = false;
    results = struct();
    results.C1_vals = [];
    results.C2_vals = [];
    results.tau_C1 = [];
    results.tau_C2 = [];
    results.AAC_sum = [];
    results.ACC_sum = [];

    M = length(czcs_set);
    if M == 0
        error('czcs_set为空');
    end
    N = length(czcs_set(1).seq);
    for m = 1:M
        if length(czcs_set(m).seq) ~= N
            error('第%d条序列长度不一致', m);
        end
    end
    
    T1 = 1:Z;
    T2 = (N-Z):(N-1);
    tau_all = -(N-1):N-1;
    
    AAC_sum = zeros(size(tau_all));
    for m = 1:M
        [~, rho_m] = aperiodic_autocorr(czcs_set(m).seq);
        AAC_sum = AAC_sum + rho_m;
    end
    idx_C1 = ismember(abs(tau_all), [T1, T2]);
    C1_vals = AAC_sum(idx_C1);
    valid_C1 = all(abs(C1_vals) < 1e-10);
    
    ACC_sum = zeros(size(tau_all));
    for m = 1:M
        m_next = mod(m, M) + 1; % 循环相邻索引
        a_m = czcs_set(m).seq;
        a_next = czcs_set(m_next).seq;
        [~, rho_mn] = aperiodic_crosscorr(a_m, a_next);
        ACC_sum = ACC_sum + rho_mn;
    end
    idx_C2 = ismember(abs(tau_all), T2);
    C2_vals = ACC_sum(idx_C2);
    valid_C2 = all(abs(C2_vals) < 1e-10);
    
    is_valid = valid_C1 && valid_C2;
    
    results.C1_vals = C1_vals;
    results.C2_vals = C2_vals;
    results.tau_C1 = tau_all(idx_C1);
    results.tau_C2 = tau_all(idx_C2);
    results.AAC_sum = AAC_sum;
    results.ACC_sum = ACC_sum;
end