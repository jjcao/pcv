function [fitting_number err] = pca_fitting(data,TP)
%% data 为输入数据，每一列为一个输入的采样点

%% centralization & compute norm
mean_data = mean(data,2);
x = data - repmat(mean_data,1,size(data,2));
[U S V] = svd(x);
norm = U(:,size(x,1));

%% computing err
err = abs(norm'*x);
mean_err = mean(err);

fitting_number = mean_err<TP.fitting_threshold;
