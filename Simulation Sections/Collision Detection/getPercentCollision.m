function [ collisionPercent ] = getPercentCollision( voxelData, vMeshB, fMeshB )
%GETPERCENTCOLLISION Returns the percent of meshA's voxels inside meshB
%==========================================================================
%
% USAGE     
%       [ collisionPercent ] = getPercentCollision( voxelData, vMeshB, fMeshB )
%
% INPUTS
%
%       voxelData   - Mandatory - Nx3 array     -List of meshA's voxel coordinates where N is the number of voxels
%
%       vMeshB      - Mandatory - Nx3 array     -List of meshB's vertex coordinates where N is the number of verteces
%
%       fMeshB      - Mandatory - Nx3 array     -List of meshB's face data where N is the number of faces
%
% OUTPUTS
%
%       collisionPercent - Mandatory - 0.0 to 1.0 value - Amount of meshA inside meshB as a percentage of voxels
%
% EXAMPLE
%
%       To get the collision of two STL files:
%       >>  [ collisionPercent ] = getPercentCollision( stlAVoxelData, stlBVerts, stlBFaces )
% 
% NOTES
%
%   -Mesh must be properly closed (ie. watertight)
%
% REFERENCES
%
%   -This code uses intriangulation by Johannes Korsawe, who based her code
%    heavily off of VOXELISE by Adam A.
%==========================================================================


%% Test the voxels in meshB
testedPoints = [voxelData(:,1), voxelData(:,2), voxelData(:,3), ...
                intriangulation(vMeshB,fMeshB,voxelData)];
%Remove all the points that tested outside meshB
condition = testedPoints(:,4)==0;
testedPoints(condition, :) = [];

%% Get number of points inside meshB
intersectingPointsCount = size(testedPoints, 1);
%Convert to a percent of total points
collisionPercent =  intersectingPointsCount / size(voxelData,1);

end