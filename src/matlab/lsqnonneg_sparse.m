function w = lsqnonneg_sparse(F, S)

% initialize w and tuning parameter beta
w = zeros(size(F, 2), 1);
beta = 0.01;
activeSet = [];

while true
    delObj = -2*F'*(S - F*w);
    [minVal, idx] = min(delObj);

    if minVal < -1*beta
        activeSet = union(activeSet, idx);
        w(idx) = 1;
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
            L = find(w_new < 0);
            ratio_to0 = w_hat(L)./(w_hat(L) - w_new(L));
            [maxV, maxL] = max(ratio_to0);
            w_hat = w_hat - (w_hat - w_new)*maxV;
            w(activeSet) = w_hat;
            activeSet(maxL) = [];
        else
            break;
        end   
    end
end



