function [ countCollide, amountCollide ] = getCollisionVoxelVoxel( objectSurfPoints, objectSurfaceArea, objectVox, resolution, sdfGrid, method )
%% GETCOLLISIONVOXELVOXEL Gets the amount of collisions between a set of voxels in both count and summed internal distance, given voxel coordinates Nx3 matrix, and a Nx4 matrix defining the SDF values at the meshgrid coordinates
%   Detailed explanation goes here
sdfValuesAtVoxels = interp3(sdfGrid(:,1),sdfGrid(:,2),sdfGrid(:,3),sdfGrid(:,4),objectVox(:,1),objectVox(:,2),objectVox(:,3),method);
%% Filter by only inside
sdfValuesAtVoxels = sdfValuesAtVoxels(sdfValuesAtVoxels>0.5);
%% Same for objectSurfPoints
sdfValuesAtSurf = interp3(sdfGrid(:,1),sdfGrid(:,2),sdfGrid(:,3),sdfGrid(:,4),objectSurfPoints(:,1),objectSurfPoints(:,2),objectSurfPoints(:,3),method);
%% Filter by only inside
sdfValuesAtSurf = sdfValuesAtSurf(sdfValuesAtSurf>0.5);
%% Get areaPerVoxel
%Get x dimension of bounding box
xRange = range(objectSurfPoints(:,1));
%Multiply by resolution to get # of voxels in that range
xVoxels = xRange * resolution;
%Devide size by number of voxels, and then cube that to get area per voxel
unitsPerVoxel = xRange / xVoxels;
volumePerVoxel = unitsPerVoxel^3;

%% Get areaPerSurfPoint
%Get surface area per point
surfAreaPerPoint = objectSurfaceArea / size(objectSurfPoints,1);
%Covert to a volume
volumePerPoint = surfAreaPerPoint ^ (3/2);
%Devide by two to compensate for edge-ness
volumePerPoint = (volumePerPoint / 2);

%% Add values together
countCollide = length(sdfValuesAtVoxels) + length(sdfValuesAtSurf);
amountCollide = length(sdfValuesAtVoxels) * volumePerVoxel + ...
                length(sdfValuesAtSurf) * volumePerPoint;
end

