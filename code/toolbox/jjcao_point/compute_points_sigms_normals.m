function [sigms normVectors errs  max_errs]= compute_points_sigms_normals(pts, k_knn, kdtree)
% COMPUTE_INITIAL_FEATURE - initial feature detection via PCA.
%
%   Input:
%
%   Output:
%          - 'featid'                  : sharp edge feature vertex id
%
% Reference:
%       (1) - Pauly, M., Keiser, R., and Gross, M.. Multi-scale feature extraction on point-sampled surface.
%             Computer. Graphics Forum. 2003, 22(3):281-289.
%
%   Changed by JJCAO
%   Copyright (c) 2012 Wangxiaochao 2012-8-30 22:40:28

DEBUG = 0;
SHOW_RESULT = 0;

npts = size(pts,1);
sigma = zeros(npts,1);
normVectors = zeros(npts,3);
errs = zeros(npts,1);

if DEBUG
    figure('Name','PCA'); set(gcf,'color','white');set(gcf,'Renderer','OpenGL'); axis off;axis equal;view3d rot; hold on;
end
for i = 1:npts
    knn = kdtree_k_nearest_neighbors(kdtree,pts(i,:),k_knn)';
    P = pts(knn,:);
    mp = mean(P);
    tmp = P-repmat(mp,k_knn,1);
    C = tmp'*tmp./k_knn;
    if DEBUG
        [V, D] = eig(C);
        d = diag(D);
        
        [bbox, diameter] = compute_bbox(P);
        h1 = scatter3(P(:,1),P(:,2),P(:,3),30,'.','MarkerEdgeColor',[1.0, .65, .35]);
        VD = V*D;
        target = repmat(mp',1,3) + VD*(diameter/max(sqrt(sum(VD.^2))));
        x(1:2:5) = mp(1);y(1:2:5) = mp(2);z(1:2:5) = mp(3);
        x(2:2:6) = target(1,:);y(2:2:6) = target(2,:);z(2:2:6) = target(3,:);
        h2 = line(x,y,z, 'LineWidth', 2, 'Color', [1.0,0.0,0.0]);
        delete(h1);delete(h2);
    else
        [V, D] = eig(C);
        d = diag(D);
    end
    sigma(i) = min(d)/sum(d);
    d = tmp * V(:,1);
    errs(i) = mean(abs(d));
    max_errs(i) = max(abs(d));
    normVectors(i,:) = V(:,1);
    %   s=svd(tmp,0);
end

%% set threshold to filter the false feature points
sigma = sigma/max(sigma);
sigms = sigma;
if SHOW_RESULT
    figure('Name','PCA'); set(gcf,'color','white');set(gcf,'Renderer','OpenGL'); axis off;axis equal;view3d rot; hold on;
    scatter3(pts(:,1),pts(:,2),pts(:,3),20,'.','MarkerEdgeColor',[1.0, .65, .35]);
    scatter3(pts(featid,1),pts(featid,2),pts(featid,3),40,'.','MarkerEdgeColor',[1.0, .0, .0]);
end

function [bbox, diameter] = compute_bbox(pts)
bbox = [min(pts(:,1)), min(pts(:,2)), min(pts(:,3)), max(pts(:,1)), max(pts(:,2)), max(pts(:,3))];
rs = bbox(4:6)-bbox(1:3);
diameter = sqrt(dot(rs,rs));