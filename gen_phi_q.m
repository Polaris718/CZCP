function phi = gen_phi_q(vec, q)
%GEN_PHI_Q Map integer phase indices to q-ary complex phase symbols.

    phi = exp(2 * pi * 1i * vec / q);
end
