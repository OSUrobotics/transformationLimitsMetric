function [ output ] = getPercentCollision( vMeshA, fMeshA, vMeshB, fMeshB, precision )
%GETPERCENTCOLLISION Returns the percent of meshA inside meshB
%   Accepts the vertex and face value of a mesh, and the
%   vertex and face data of another mesh mesh.  Returns the percent of
%   meshA's voxelised points that are inside of meshB.  Uses
%   intriangulation.

%Get the voxel verteces of meshA
voxelA = getVoxelisedVerts(vMeshA, fMeshA, precision);
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