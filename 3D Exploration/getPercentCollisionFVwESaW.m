function [ output ] = getPercentCollisionFVwESaW( vMeshA, fMeshA, surfA, volA, vMeshB, fMeshB )
%GETPERCENTCOLLISIONFVWES Returns the percent of meshA inside meshB
%   
hold on
axis image
%Get the voxel verteces of meshA
voxelA = getVoxelisedVerts(vMeshA,fMeshA, 0.5);
%Test the voxels in meshB
testedPoints = [voxelA(:,1), voxelA(:,2), voxelA(:,3), intriangulation(vMeshB,fMeshB,voxelA)];
%Remove all the points that tested outside meshB
condition = testedPoints(:,4)==0;
testedPoints(condition, :) = [];

%Test the vertecies in meshB
testedVerts = [vMeshA(:,1),vMeshA(:,2),vMeshA(:,3), intriangulation(vMeshB,fMeshB,vMeshA)];
condition = testedVerts(:,4)==0;
testedVerts(condition, :) = [];

%Weight and add values
ratio = size(voxelA, 1) / size(vMeshA, 1);
voxelValue = size(testedPoints, 1) / ratio;
vertexValue = size(testedPoints, 1) * ratio;

%Get number of points inside meshB
intersectingPointsCount = voxelValue + vertexValue;
%Convert to a percent of total points
collisionFraction =  intersectingPointsCount / (size(voxelA,1) + size(vMeshA,1));
output = collisionFraction * 100
end