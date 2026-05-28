function czcs_set = czcs_from_czcp(a, b, M)
% 由 CZCP 序列对构造交替 CZCS 集合。
%   M 必须为偶数；奇数位置使用 a，偶数位置使用 b。

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
