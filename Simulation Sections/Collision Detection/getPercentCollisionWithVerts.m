function [ collisionPercent ] = getPercentCollisionWithVerts( meshAVerts, meshAVoxels, meshBVerts, meshBFaces, resolution, pmDepth, pmScale )
%GETPERCENTCOLLISIONFVWES Returns the percent of meshA inside meshB
%==========================================================================
%
% USAGE
%       [ collisionPercent ] = getPercentCollisionWithVerts( meshAVerts, meshAVoxels, meshBVerts, meshBFaces, resolution, pmDepth, pmScale )
%
% INPUTS
%
%       meshAVerts  - Mandatory - Nx3 array         -List of meshA's vertex coordinates where N is the number of verteces
%
%       meshAVoxels - Mandatory - Nx3 array         -List of meshA's voxel coordinates where N is the number of voxels
%
%       meshBVerts - Mandatory - Nx3 array          -List of meshB's vertex coordinates where N is the number of verteces
%
%       meshBFaces - Mandatory - Nx3 array          -List of meshB's face data where N is the number of faces
%
%       resolution - Mandatory - 0.0 to 1.0 value   -The resolution passed to getVoxelisedVerts when generating meshAVoxels
%
%       pmDepth - Mandatory - Integer value         -The argument passed to PolyMender for octree depth
%
%       pmScale - Mandatory - 0.0 to 1.0 value      -The argument passed to PolyMender for scale
%
% OUTPUTS
%
%       collisionPercent - Mandatory - 0.0 to 1.0 value - Amount of meshA inside meshB as a percentage
%
% EXAMPLE
%
%       To get the collision of a PolyMended ply file with an stl file:
%       >>  [ collisionPercent ] = getPercentCollisionWithVerts( plyVerts, plyVoxels, stlVerts, stlVoxels, voxelResolution, polyMenderOctreeDepth, polyMenderScale )
%
% NOTES
%
%   -Both meshes must be properly closed (ie. watertight).
%   -Mesh a must have been run through PolyMender, and the values input 
%    must match the arguments used.
%   -The resolution value must match the one passed to getVoxelisedVerts 
%    to get the voxel data for meshA.
%
% REFERENCES
%
%   -This code uses intriangulation by Johannes Korsawe, who based her code
%    heavily off of VOXELISE by Adam A.
%==========================================================================

%% Test the voxels in meshB
testedPoints = [meshAVoxels(:,1), meshAVoxels(:,2), meshAVoxels(:,3), ...
                intriangulation(meshBVerts,meshBFaces,meshAVoxels)];
%Remove all the points that tested outside meshB
condition = testedPoints(:,4)==0;
testedPoints(condition, :) = [];

%% Test the vertecies in meshB
testedVerts = [meshAVerts(:,1),meshAVerts(:,2),meshAVerts(:,3), ...
               intriangulation(meshBVerts,meshBFaces,meshAVerts)];
%Remove all the points that tested outside meshB
condition = testedVerts(:,4)==0;
testedVerts(condition, :) = [];

%% Get areaPerVoxel
%Get x dimension of bounding box
xRange = range(meshAVoxels(:,1));
%Multiply by resolution to get # of voxels in that range
xVoxels = xRange * resolution;
%Devide size by number of voxels, and then cube that to get area per voxel
unitsPerVoxel = xRange / xVoxels;
areaPerVoxel = unitsPerVoxel^3;

%% Get areaPerVertex
%Take an argument of octree depth and scale for polymender
%Get max dimension of object
ranges = [range(meshAVerts(:,1)), range(meshAVerts(:,2)), ...
          range(meshAVerts(:,3))];
maxDimension = max(ranges);
%Get number of voxels
meshVoxels = 2^pmDepth;
%Convert into units per voxel
mUnitsPerVoxel = (maxDimension * pmScale) / meshVoxels;
%Devide by two to compensate for edge-ness, then cube
areaPerVertex = (mUnitsPerVoxel / 2)^3;

%% Calculate Volume Intersection
%Add number of verts * areaPerVertex to voxels * areaPerVoxel to get total
%area
totalArea = size(meshAVerts(:,1)) * areaPerVertex + ...
            size(meshAVoxels(:,1)) * areaPerVoxel;
%Add collidingVerts * areaPerVertx to collidingVoxels * areaPerVoxel to get
%total area colliding
totalAreaColliding = size(testedVerts(:,1)) * areaPerVertex + ...
                     size(testedPoints(:,1)) * areaPerVoxel;
%Devide area colliding by total area to get a value 0.0 - 1.0 representing
%percent of object colliding with meshB
collisionPercent = totalAreaColliding / totalArea;
end