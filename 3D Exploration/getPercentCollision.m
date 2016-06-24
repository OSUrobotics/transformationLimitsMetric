function [ output ] = getPercentCollision( vMeshA, fMeshA, vMeshB, fMeshB )
%GETPERCENTCOLLISION Returns the percent of meshA inside meshB
%   Detailed explanation goes here

%Get the voxel verteces of meshA
voxelA = getVoxelisedVerts(vMeshA, fMeshA, 0.5);
%Test meshA's voxels in meshB
testedPoints = [voxelA(:,1), voxelA(:,2), voxelA(:,3), intriangulation(vMeshB,fMeshB,voxelA)];
%Remove all the points that tested outside meshB
condition = testedPoints(:,4)==0;
testedPoints(condition, :) = [];
%Get number of points inside meshB
intersectingPointsCount = size(testedPoints, 1);
%Convert to a percent of total points
collisionFraction =  intersectingPointsCount / size(voxelA,1);
output = collisionFraction * 100;
end