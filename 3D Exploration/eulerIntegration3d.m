function [ ptsOut ] = eulerIntegration3d( transformMatrixIn, pts, stepNums )
%EULERINTEGRATION3D takes a transformation matrix in and calculates the euler integration process in applying the transformation to points
%   inputs:
% transformMatrixIn: the transformation matrix in as would be linerally applied to the points.
% pts: said points
% stepNums: the number of iterations in the loop, more is more accurate. The stepSize is 1/stepNums.
%% Get the step transformation matrix
stepMatrix = 1/stepNums*transformMatrixIn;
%% Establish the finish points matrix
ptsOut = zeros([size(pts) stepNums]);
ptsOut(:,:,1) = pts;
%% Coloring for testing data
cmap = spring(stepNums);
scatter3(ptsOut(:,1,1),ptsOut(:,2,1),ptsOut(:,3,1),'.','MarkerFaceColor',cmap(1,:));
hold on
%% Apply the matrix iteratively to the pts
for index = 2:stepNums
    ptsOut(:,:,index)=ptsOut(:,:,index-1)*stepMatrix;
    scatter3(ptsOut(:,1,index),ptsOut(:,2,index),ptsOut(:,3,index),'.','MarkerFaceColor',cmap(index,:));
    hold on
    pause
end
end

