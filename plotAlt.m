function plotAlt( varargin )
%% PLOTALT Plot a horizontal or vertical list of data points, with extra arguments passed along
pts = varargin{1};
if size(pts,2) == 3 && size(pts,1) ~= 3
    plot3(pts(:,1),pts(:,2),pts(:,3),varargin{2:end});
elseif size(pts,1) == 3 && size(pts,2) ~= 3
    plot3(pts(1,:),pts(2,:),pts(3,:),varargin{2:end});
end
end