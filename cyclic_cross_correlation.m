function phi = cyclic_cross_correlation(a, b, tau, method)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    
    % Implementation note.
    if nargin < 4
        method = 'inner';
    end
    
    % Implementation note.
    a = a(:);
    b = b(:);
    N = length(a);
    
    % Implementation note.
    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end
    
    % Implementation note.
    if strcmp(method, 'inner')
        b_shift = cyclic_shift_left(b, tau);  % Implementation note.
        phi = a.' * conj(b_shift);  % Implementation note.
    % Implementation note.
    elseif strcmp(method, 'sum')
        phi = 0;
        for n = 0 : N-1
            % Implementation note.
            idx = mod(n + tau, N) + 1;  % Implementation note.
            phi = phi + a(n+1) * conj(b(idx));  % Implementation note.
        end
    else
        error('Invalid input''inner''Invalid input''sum''');
    end
end
