function h = plot_mesh(vertex,face,options)

% plot_mesh - plot a 3D mesh.
%
%   turn off vsync in the nvidia control panel, will speed up renderering!!!!
%
%   'options' is a structure that may contains:
%       - 'normal' : a (nvertx x 3) array specifying the normals at each vertex.
%       - 'fnormal': a (nface x 3) array specifying the normals at each face.
%       - 'normal_scaling': a double normal scale.
%       - 'subsample_normal': a double normal sample ratio.
%       - 'edge_color' : a float specifying the color of the edges.
%       - 'face_color' : a float specifying the color of the faces.
%       - 'face_vertex_color' : a color per vertex or face.
%       - 'vertex'
%
%   See also: mesh_previewer.
%   changed by jjcao 2009, 2012
%   Copyright (c) 2004 Gabriel Peyr?

if nargin<2
    error('Not enough arguments.');
end

options.null = 0;

normal          = getoptions(options, 'normal', []);
fnormal          = getoptions(options, 'fnormal', []);
face_color      = getoptions(options, 'face_color', [194 212 246]/255);
edge_color      = getoptions(options, 'edge_color', [1 1 1]*0);
normal_scaling  = getoptions(options, 'normal_scaling', .8);
alfa            = getoptions(options, 'alfa', 1);
if (alfa > 1) alfa = 1;end
if (alfa < 0) alfa = 0;end;

if ~isfield(options, 'face_vertex_color')
    %don't need 'face_vertex_color' indexing
    face_vertex_color=[];
elseif isempty(options.face_vertex_color)
    %default indexing color per vertex
    options.face_vertex_color = ones(size(vertex,1),1)*192/255;
    face_vertex_color = options.face_vertex_color;
else
    %customized indexing color per face/vertex
    face_vertex_color = options.face_vertex_color;
end

if isempty(face_vertex_color)
    h = patch('vertices',vertex,'faces',face,'facecolor',face_color,'edgecolor',edge_color, 'FaceAlpha', alfa);
else
    if size(face_vertex_color,1)==size(vertex,1)
        shading_type = 'interp';
    else
        shading_type = 'flat';
    end
    h = patch('vertices',vertex,'faces',face,'FaceVertexCData',face_vertex_color,...
        'FaceColor',shading_type, 'FaceAlpha', alfa);
    colormap hsv;
    colorbar;
end
% alpha(0.8);
lighting phong;
camproj('perspective');
axis square;
axis off;

if ~isempty(normal)
    % plot the normals
    n = size(vertex,1);
    subsample_normal = getoptions(options, 'subsample_normal', min(4000/n,1) );
    sel = randperm(n); sel = sel(1:floor(end*subsample_normal));
    hold on;
    quiver3(vertex(sel,1),vertex(sel,2),vertex(sel,3),normal(sel,1),normal(sel,2),normal(sel,3),normal_scaling);
    hold off;
end

if ~isempty(fnormal)
    % plot the face's normals
    n = size(face,1);
    subsample_normal = getoptions(options, 'subsample_normal', min(4000/n,1) );
    sel = randperm(n); sel = sel(1:floor(end*subsample_normal));
    bc = getoptions(options, 'barycentre', barycentre(vertex,face) );
    hold on;
    quiver3(bc(sel,1),bc(sel,2),bc(sel,3),fnormal(sel,1),fnormal(sel,2),fnormal(sel,3),normal_scaling);
    hold off;
end

cameramenu;
axis equal;
camlight;