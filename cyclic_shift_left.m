function T_minus_tau = cyclic_shift_left(x, tau)
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。
    % 实现说明。

    % 实现说明。
    x = x(:);
    N = length(x);

    % 实现说明。
    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    % 实现说明。
    if tau == 0
        T_minus_tau = x;
        return;
    end

    % 实现说明。
    % 实现说明。
    part1 = x(tau + 1 : N);
    % 实现说明。
    part2 = x(1 : tau);

    % 实现说明。
    T_minus_tau = [part1; part2];
end
