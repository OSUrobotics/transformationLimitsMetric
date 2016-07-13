function [ amountCollide, countCollide ] = getCollisionVoxelVoxelScatter( handVox, objectVox, objectSurfPoints, objectSurfaceArea, resolution )
%% GETCOLLISIONVOXELVOXELSCATTER Gets the amount of collisions between a set of voxels in both count and summed internal distance, given voxel coordinates Nx3 matrix, and a Nx4 matrix defining the SDF values at the meshgrid coordinates
%   Detailed explanation goes here
functionHand = scatteredInterpolant(handVox(:,1),handVox(:,2),handVox(:,3),ones(size(handVox,1),1));
%% Apply the given function to the object voxels
valuesAtVoxels = functionHand(objectVox(:,1),objectVox(:,2),objectVox(:,3));
%% Same for objectSurfPoints
valuesAtSurf = functionHand(objectSurfPoints(:,1),objectSurfPoints(:,2),objectSurfPoints(:,3));
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
countCollide = length(valuesAtVoxels) + length(valuesAtSurf);
amountCollide = length(valuesAtVoxels) * volumePerVoxel + ...
                length(valuesAtSurf) * volumePerPoint;
end

