function czcs_set = czcs_from_czcp(a, b, M)
%CZCS_FROM_CZCP Build an alternating CZCS set from a CZCP pair.
%   M must be even. Odd positions use a, and even positions use b.

    if mod(M, 2) ~= 0
        error('M must be even.');
    end
    if length(a) ~= length(b)
        error('a and b must have the same length.');
    end

    for m = 1:M
        if mod(m, 2) == 1
            czcs_set(m).seq = a;
        else
            czcs_set(m).seq = b;
        end
    end
end
