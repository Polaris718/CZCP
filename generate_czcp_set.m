%公式(22)：CZCP序列集合生成
function czcp_set = generate_czcp_set(e, f, q, v1, v2, v)
    % 输入：
    %   e, f - 基序列对（行向量或列向量）
    %   q    - 单位根阶数（如4元序列q=4）
    %   v1, v2, v - 任意整数（相位旋转参数）
    % 输出：
    %   czcp_set - 包含4组CZCP序列对的结构体
    %             每组格式：.a, .b（生成的序列对）

    % 1. 预处理：统一转为行向量
    e = e(:).'; 
    f = f(:).';
    
    % 2. 计算q次单位根
    omega_q = exp(1i * 2 * pi / q);
    
    % 3. 计算旋转后的基序列
    % 第一部分（上半段）的旋转
    e_v1 = omega_q^v1 * e;
    f_v1_v = omega_q^(v1 + v) * f;
    % 第二部分（下半段）的旋转
    e_v2 = omega_q^v2 * e;
    f_v2_v = omega_q^(v2 + v) * f;
    % 交换e和f后的旋转（用于第3、4组）
    f_v1 = omega_q^v1 * f;
    e_v1_v = omega_q^(v1 + v) * e;
    f_v2 = omega_q^v2 * f;
    e_v2_v = omega_q^(v2 + v) * e;

    % 4. 生成4组CZCP序列对（按公式22顺序）
    % 第1组：[e_v1, f_v1_v; e_v2, -f_v2_v]
    czcp_set(1).a = [e_v1, f_v1_v];  % 上半段拼接
    czcp_set(1).b = [e_v2, -f_v2_v]; % 下半段拼接
    
    % 第2组：[e_v1, -f_v1_v; e_v2, f_v2_v]
    czcp_set(2).a = [e_v1, -f_v1_v];
    czcp_set(2).b = [e_v2, f_v2_v];
    
    % 第3组：[f_v1, e_v1_v; f_v2, -e_v2_v]（交换e和f）
    czcp_set(3).a = [f_v1, e_v1_v];
    czcp_set(3).b = [f_v2, -e_v2_v];
    
    % 第4组：[f_v1, -e_v1_v; f_v2, e_v2_v]（交换e和f）
    czcp_set(4).a = [f_v1, -e_v1_v];
    czcp_set(4).b = [f_v2, e_v2_v];
end
