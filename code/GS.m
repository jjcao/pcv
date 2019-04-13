
% Copyright (c) 2012 Junjie Cao

classdef GS
    % global settings    
    properties (Constant)
%         PC_COLOR = [0.275, .337, .60]; // blue
        PC_COLOR = [1.0, .75, .35]; % point cloud color, orange
        CLASS_COLOR1 = [1.0, 0.0, 0.0]; % red
%         CUT_NHR_COLOR = [1, .73, .0]; % gold
        CLASS_COLOR2 = [0.5, 1.0, .5];
        CLASS_COLOR3 = [1.0, 1.0, 0.0];
        CLASS_COLOR4 = [0.0 0.0 1.0];
        CLASS_COLOR5 = [0.0 1.0 1.0];
        
        MIN_NEIGHBOR_NUM = 8;
        MAX_NEIGHBOR_NUM = 30;% orginal 30
    end
    
    methods (Static)
        function [pts] = normalize(pts)
            % scale to unitBox and move to origin
            bbox = [min(pts(:,1)), min(pts(:,2)), min(pts(:,3)), max(pts(:,1)), max(pts(:,2)), max(pts(:,3))];
            c = (bbox(4:6)+bbox(1:3))*0.5;            
            pts = pts - repmat(c, size(pts,1), 1);
            s = 1.6 / max(bbox(4:6)-bbox(1:3));% make the bbox's diagnol = 1.6. %1.0, 1.6
            pts = pts*s;
        end
        function [] = test_normalize(pts)
            pts = GS.normalize(pts);
            [bbox, diameter] = GS.compute_bbox(pts);
            tmp = max(bbox(4:6)-bbox(1:3));
            if abs(tmp-1.0) > eps
                warning('GS.normalize() is wrong! the bounding box diagonal is: "%s" ', tmp);
            end
        end        
        function [bbox, diameter] = compute_bbox(pts)
            bbox = [min(pts(:,1)), min(pts(:,2)), min(pts(:,3)), max(pts(:,1)), max(pts(:,2)), max(pts(:,3))];
            rs = bbox(4:6)-bbox(1:3);
            diameter = sqrt(dot(rs,rs));
        end
    end
end