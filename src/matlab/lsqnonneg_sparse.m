function w = lsqnonneg_sparse(F, S)

% initialize w and tuning parameter beta
w = zeros(size(F, 2), 1);
beta = 0.01;
activeSet = [];

while true
    delObj = -2*F'*(S - F*w);
    minVal = max(delObj);
    idx = find(delObj == minVal);
    if minVal < -1*beta
        activeSet = union(activeSet, idx);
        w(idx) = 1; % this w(idx) should be assigned with 0+
    else
        return;
    end
    sign_vec = -1;
    
    while sum(sign_vec < 0) 
        F_hat = F(:, activeSet);
        w_hat = w(activeSet);
        w_new = pinv(F_hat'*F_hat)*(F_hat'*S - beta/2*ones(size(F_hat, 2), 1));
        sign_vec = w_hat.*w_new;
        
        if sum(sign_vec < 0)
            w_hat = toNew(w_hat, w_new);
            w(activeSet) = w_hat;
            activeSet(w_hat == 0) = [];
        else
            break;
        end   
    end
end


function CC = toNew(AA, BB)
dirToP      = AA - BB;
dirTo0      = AA;
rat_0_and_P = dirTo0./dirToP;
maxV        = min(rat_0_and_P(BB < 0));
CC          = AA - dirToP*maxV;
