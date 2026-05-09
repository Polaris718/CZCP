function phi = gen_phi_q(vec, q)
    % 根据公式(7)生成复指数向量
    % vec: 输入向量 (如 g 或 h)
    % q: q次单位根参数
    phi = exp(2 * pi * 1i * vec / q); 
end