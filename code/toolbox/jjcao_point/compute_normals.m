function normVectors= compute_normals(pts, k_knn, kdtree)
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

npts = size(pts,1);
normVectors = zeros(npts,3);

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
    normVectors(i,:) = V(:,1);
    %   s=svd(tmp,0);
end

function [bbox, diameter] = compute_bbox(pts)
bbox = [min(pts(:,1)), min(pts(:,2)), min(pts(:,3)), max(pts(:,1)), max(pts(:,2)), max(pts(:,3))];
rs = bbox(4:6)-bbox(1:3);
diameter = sqrt(dot(rs,rs));