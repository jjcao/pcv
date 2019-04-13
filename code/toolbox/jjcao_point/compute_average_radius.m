function [l sum_d] = compute_average_radius(V,number,kdtree)
% compute the average edge length of the point cloud V
% Input:     V are the vertex and face of a mesh.
% Output:    l is the average radius of each point
%%
if nargin <2
    number  = 2;
end

nSample = size(V,1);
for i = 1:nSample
    short_edge_id = kdtree_k_nearest_neighbors(kdtree,V(i,:),number);
    v = repmat(V(i,:),number,1) - V(short_edge_id,:);
    d = sqrt(sum(v.*v,2));
    sum_d(i) = sum(d)/(number - 1);
end
% direct link
l = sum(sum_d)/(nSample);
