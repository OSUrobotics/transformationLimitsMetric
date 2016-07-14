 function [ amountCollide ] = getCollisionVoxelVoxelScatter( handVoxWVals, objectVox, objectSurfPoints, objectSurfaceArea, resolution )
%% GETCOLLISIONVOXELVOXELSCATTER Gets the amount of collisions between a set of voxels in both count and summed internal distance, given voxel coordinates Nx3 matrix, and a Nx4 matrix defining the SDF values at the meshgrid coordinates
%   Detailed explanation goes here
functionHand = scatteredInterpolant(handVoxWVals(:,1),handVoxWVals(:,2),handVoxWVals(:,3),handVoxWVals(:,4));
%% Apply the given function to the object voxels
valuesAtVoxels = functionHand(objectVox(:,1),objectVox(:,2),objectVox(:,3));
%% Same for objectSurfPoints
valuesAtSurf = functionHand(objectSurfPoints(:,1),objectSurfPoints(:,2),objectSurfPoints(:,3));
%% Get areaPerVoxel
%Get max dimension of bounding box
maxRange = max([range(objectSurfPoints(:,1)),range(objectSurfPoints(:,2)),range(objectSurfPoints(:,3))]);
%Devide size by number of voxels, and then cube that to get area per voxel
volumePerVoxel = (maxRange / resolution)^3;

%% Get areaPerSurfPoint
%Get surface area per point
surfAreaPerPoint = objectSurfaceArea / size(objectSurfPoints,1);
%Covert to a volume
volumePerPoint = surfAreaPerPoint * (sqrt(surfAreaPerPoint));
%Devide by two to compensate for edge-ness
volumePerPoint = (volumePerPoint / 2);

%% Add values together
amountCollide = length(valuesAtVoxels) * volumePerVoxel + ...
                length(valuesAtSurf) * volumePerPoint;
end

