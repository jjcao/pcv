function [feat max_sigm_bar] = feature_threshold_selection(sigms,TP)

DEBUG = TP.debug_taproot;
length_taproot = 50;
%%
for i = 1:length_taproot
    taproot(i) = length(find(sigms>=((i-1)*(1/length_taproot)))) - length(find(sigms>=((i)*(1/length_taproot))));
end
[m_value m_id] = max(taproot);
max_sigm_bar = m_id/length_taproot;
uni_taproot = taproot/m_value;
y = uni_taproot';
n = length(y);
e = ones(n,1);
D = spdiags([e -e], 0:1, n-1, n);
delt = D*y;

%% solve L1 trend filtering problem
% set regularization parameter
lambda = 0.5;
cvx_begin
variable x1(n)
minimize( 0.5*sum_square(y-x1)+lambda*norm(D*x1,1) );
cvx_end
%%
for i = (m_id+1):length_taproot-1
    diff_taproot = x1(i-1) - x1(i+1);
    if (diff_taproot < TP.sigma_threshold)&&(x1(i)<(x1(m_id)-TP.sigma_threshold))
        feat = i * (1/length_taproot);
        break
    end
end
%%
if DEBUG
    figure
    x = [1:50]*1/50;
    plot(x,taproot,'LineWidth',3.0); hold on
    plot(x,x1*m_value,'m-','LineWidth',3.0); hold on;
    xf = (ones(1,m_value+1) * feat * length_taproot)*1/50;
    yf = 0:m_value;
end






