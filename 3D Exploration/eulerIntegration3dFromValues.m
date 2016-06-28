function [ ptsOut ] = eulerIntegration3dFromValues( values, pts, stepNums, translateScalar)
%EULERINTEGRATION3DFROMVALUES 
%% Apply the scalar to the translation values
values(1:3) = translateScalar*values(1:3);
%% Get the step transformation matrix
stepMatrix = makehgtform('translate',values(1:3)*1/stepNums,'axisrotate',values(4:6),values(7)*1/stepNums);
stepMatrix(4,4) = 1;
%% Establish the finish points matrix
ptsOut = ones([size(pts,1) size(pts,2)+1 stepNums]); % Done strange so padding 1 for 4x4 transformations
ptsOut(:,1:3,1) = pts;
%% Coloring for testing data
% clf, close all;
cmap = summer(stepNums);
plot3(ptsOut(:,1,1),ptsOut(:,2,1),ptsOut(:,3,1),'.-','Color',cmap(1,:));
hold on
%% Apply the matrix iteratively to the pts
for index = 2:stepNums
    ptsOut(:,:,index)=ptsOut(:,:,index-1)*stepMatrix';
    %% Test the transformation
    plot3(ptsOut(:,1,index),ptsOut(:,2,index),ptsOut(:,3,index),'.-','Color',cmap(index,:));
    hold on
    % pause
end
end