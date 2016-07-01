function visualizeTransformations( pts, faces )
%%VISUALIZETRANSFORMATIONS Takes 3D matrix of points with indexes [value, axis, stepIndex] visualizes the steps in a transformation with a color gradient
% pts: a 3d array of points, indexed like [# points, 3, timeStep]
% faces: used in visualizing the stl files, only needed if that. Will be the 2d matrix and used for all time steps

if nargin == 1 % If ploting the points alone, not an STL file
    %% Make a colormap
    cmap = summer(size(pts,3));
    %% Plot the points
    for index = 1:size(pts,3)
        if ~unique(isnan(pts(:,:,index)))
            plot3(pts(:,1,index),pts(:,2,index),pts(:,3,index),'.-','Color',cmap(index,:));
            hold on
        end
    end
else % Plotting an STL file
    for index = 1:size(pts,3)
        stlPlot(pts(:,:,index), faces, false);
    end
end
end