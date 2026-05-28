function phi = gen_phi_q(vec, q)
% 将整数相位指数映射为 q 元复相位符号。

    phi = exp(2 * pi * 1i * vec / q);
end
