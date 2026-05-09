%% 基于CZCP构造CZCS
function czcs_set = czcs_from_czcp(a, b, M)
    % 输入：
    %   a, b - 基础(N,Z)-CZCP序列对
    %   M    - 目标CZCS的序列数，必须为偶数
    % 输出：
    %   czcs_set - 结构体数组，czcs_set(m).seq 为第m条序列
    
    if mod(M, 2) ~= 0
        error('论文构造方法要求M必须为偶数');
    end
    if length(a) ~= length(b)
        error('CZCP序列a和b长度必须相同');
    end
    
    for m = 1:M
        if mod(m, 2) == 1
            czcs_set(m).seq = a;
        else
            czcs_set(m).seq = b;
        end
    end
end