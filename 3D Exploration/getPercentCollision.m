function [ output ] = getPercentCollision( voxelData, vMeshB, fMeshB )
%GETPERCENTCOLLISION Returns the percent of voxelData inside meshB
%   Accepts an Nx3 array of vectors representing points in space, and the
%   vertex and face data of a mesh.  Returns the percent of voxelData's
%   points that are inside MeshB.  Uses intriangulation.

%Get the voxel verteces of meshA
voxelA = voxelData;
%Test the voxels in meshB
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