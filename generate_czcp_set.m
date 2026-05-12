% Implementation note.
function czcp_set = generate_czcp_set(e, f, q, v1, v2, v)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.

    % Implementation note.
    e = e(:).'; 
    f = f(:).';
    
    % Implementation note.
    omega_q = exp(1i * 2 * pi / q);
    
    % Implementation note.
    % Implementation note.
    e_v1 = omega_q^v1 * e;
    f_v1_v = omega_q^(v1 + v) * f;
    % Implementation note.
    e_v2 = omega_q^v2 * e;
    f_v2_v = omega_q^(v2 + v) * f;
    % Implementation note.
    f_v1 = omega_q^v1 * f;
    e_v1_v = omega_q^(v1 + v) * e;
    f_v2 = omega_q^v2 * f;
    e_v2_v = omega_q^(v2 + v) * e;

    % Implementation note.
    % Implementation note.
    czcp_set(1).a = [e_v1, f_v1_v];  % Implementation note.
    czcp_set(1).b = [e_v2, -f_v2_v];  % Implementation note.
    
    % Implementation note.
    czcp_set(2).a = [e_v1, -f_v1_v];
    czcp_set(2).b = [e_v2, f_v2_v];
    
    % Implementation note.
    czcp_set(3).a = [f_v1, e_v1_v];
    czcp_set(3).b = [f_v2, -e_v2_v];
    
    % Implementation note.
    czcp_set(4).a = [f_v1, -e_v1_v];
    czcp_set(4).b = [f_v2, e_v2_v];
end
