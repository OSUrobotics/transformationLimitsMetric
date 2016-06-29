function visualizeTransformations( pts )
%VISUALIZETRANSFORMATIONS Takes 3D matrix of points with indexes [value, axis, stepIndex]
%   visualizes the steps in a transformation with a color gradient
% %% Clear the figure
% close all, clf, figure;
%% Make a colormap
cmap = summer(size(pts,3));
%% Plot the points
for index = 1:size(pts,3)
    plot3(pts(:,1,index),pts(:,2,index),pts(:,3,index),'.-','Color',cmap(index,:));
    hold on
end
end