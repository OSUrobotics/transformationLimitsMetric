function [ output ] = getPercentCollisionFVwES( vMeshA, fMeshA, vMeshB, fMeshB )
%GETPERCENTCOLLISIONFVWES Returns the percent of meshA inside meshB
%   
hold on
axis image
%Get the voxel verteces of meshA
voxelA = getVoxelisedVerts(vMeshA,fMeshA, 0.5);
scatter3(voxelA(:,1),voxelA(:,2),voxelA(:,3), '.k');
%Add the objects verts to the voxel verts
scatter3(vMeshA(:,1),vMeshA(:,2),vMeshA(:,3),'filled', 'sr');
voxelA = [voxelA; vMeshA];
% %Test the voxels in meshB
% testedPoints = [voxelA(:,1), voxelA(:,2), voxelA(:,3), intriangulation(vMeshB,fMeshB,voxelA)];
% %Remove all the points that tested outside meshB
% condition = testedPoints(:,4)==0;
% testedPoints(condition, :) = [];
% %Get number of points inside meshB
% intersectingPointsCount = size(testedPoints, 1);
% %Convert to a percent of total points
% collisionFraction =  intersectingPointsCount / size(voxelA,1);
% output = collisionFraction * 100;
% end