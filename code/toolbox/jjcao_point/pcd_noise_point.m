function [overts] = pcd_noise_point(varargin)
%pcd_noise Add noise to point cloud.
%   overts = pcd_noise(verts,TYPE,...) Add noise of a given TYPE to the point cloud verts.
%   TYPE is a string that can have one of these values:
%
%       'random'         implement of Random vertex displacement in MeshLab
%       'gaussian'       Gaussian white noise with constant mean (0) and variance
%
%       'salt & pepper'  Generate some random samples with uniform distribution in the bounding box
%                        of the shape
%
%   Depending on TYPE, you can specify additional parameters to pcd_noise.
%
%   overts = pcd_noise(verts,'gaussian',V) adds Gaussian white noise of mean 0 and
%   variance V*R to the point cloud verts, where R is the bounding radius mentioned in
%   Reconstruction of Solid Models from Oriented Point Sets_sgp05.
%   When unspecified, V default to 0.01.
%
%   overts = pcd_noise(verts,'salt & pepper',D) adds "salt and pepper" noise to the point cloud
%   verts, where D is the noise density.  This affects approximately D*numel(I) pixels.
%   The default for D is 0.05.
%
%   Example
%   -------
%        [M.verts,M.faces] = read_mesh('../data/horse_v11912.off');
%        overts = imnoise(M.verts,'salt & pepper', 0.02);
%        plot_mesh(M.verts, M.faces);
%        plot_mesh(overts, M.faces);
%
%   Copyright 2010 JJCAO
verts = varargin{1};
TYPE  = varargin{2};
base = varargin{3};
p3  = varargin{4};
kdtree = varargin{5};
%
switch base
    case 'average_edge' % Random vertex displacement in MeshLab
        diameter =  compute_average_radius(verts, 2, kdtree);
    case 'diagonal_line' % Gaussian white noise
        bbox = [min(verts(:,1)), min(verts(:,2)), min(verts(:,3)), max(verts(:,1)), max(verts(:,2)), max(verts(:,3))];
        bx = bbox(4)-bbox(1);by = bbox(5)-bbox(2);bz = bbox(6)-bbox(3);
        rs = bbox(4:6)-bbox(1:3);
        diameter = sqrt(dot(rs,rs));
end


switch TYPE
    case 'random' % Random vertex displacement in MeshLab
        overts = verts + (2.0*rand(size(verts)) - 1) * diameter * p3;%rand: uniform distribution
    case 'gaussian' % Gaussian white noise
%         overts = verts + sqrt(p3*diameter*0.5)*randn(size(verts));%randn: normal distribution
        overts = verts + p3*diameter*randn(size(verts));%randn: normal distribution
%         x = rand(length(verts),1);
%         tmp = find(x < 0.05);
%         overts(tmp,1) = overts(tmp,1) + 0.05*diameter*randn(length(tmp),1);
%         overts(tmp,2) = overts(tmp,2) + 0.05*diameter*randn(length(tmp),1);
%         overts(tmp,3) = overts(tmp,3) + 0.05*diameter*randn(length(tmp),1);
        %overts = verts + sqrt(p3)*diameter*randn(size(verts));
    case 'salt & pepper' % Salt & pepper noise
        overts = verts;
        x = rand(length(verts),1);
        tmp =x < p3;
        overts(tmp,1) = bbox(1) + bx*rand(sum(tmp), 1);
        overts(tmp,2) = bbox(2) + by*rand(sum(tmp), 1);
        overts(tmp,3) = bbox(3) + bz*rand(sum(tmp), 1);
end
end