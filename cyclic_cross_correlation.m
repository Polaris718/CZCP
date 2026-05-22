function phi = cyclic_cross_correlation(a, b, tau, method)
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    
    % 实现说明。
    if nargin < 4
        method = 'inner';
    end
    
    % 实现说明。
    a = a(:);
    b = b(:);
    N = length(a);
    
    % 实现说明。
    if length(b) ~= N
        error('Invalid input: %d, %d', N, length(b));
    end
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end
    
    % 实现说明。
    if strcmp(method, 'inner')
        b_shift = cyclic_shift_left(b, tau);  % 实现说明。
        phi = a.' * conj(b_shift);  % 实现说明。
    % 实现说明。
    elseif strcmp(method, 'sum')
        phi = 0;
        for n = 0 : N-1
            % 实现说明。
            idx = mod(n + tau, N) + 1;  % 实现说明。
            phi = phi + a(n+1) * conj(b(idx));  % 实现说明。
        end
    else
        error('Invalid input''inner''Invalid input''sum''');
    end
end
