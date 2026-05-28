function T_minus_tau = cyclic_shift_left(x, tau)
%CYCLIC_SHIFT_LEFT Circularly shift a vector left by tau samples.

    x = x(:);
    N = length(x);

    if tau < 0 || tau >= N
        error('Invalid input: %d', N);
    end

    if tau == 0
        T_minus_tau = x;
        return;
    end

    part1 = x(tau + 1:N);
    part2 = x(1:tau);
    T_minus_tau = [part1; part2];
end
