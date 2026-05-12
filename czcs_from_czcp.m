%% Verification or construction step
function czcs_set = czcs_from_czcp(a, b, M)
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    % Implementation note.
    
    if mod(M, 2) ~= 0
        error('Invalid input');
    end
    if length(a) ~= length(b)
        error('Invalid input');
    end
    
    for m = 1:M
        if mod(m, 2) == 1
            czcs_set(m).seq = a;
        else
            czcs_set(m).seq = b;
        end
    end
end
