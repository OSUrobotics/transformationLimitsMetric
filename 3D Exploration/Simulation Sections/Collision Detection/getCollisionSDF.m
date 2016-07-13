function [ countCollide, summedCollide ] = getCollisionSDF( objectVox, sdfGrid, method )
%% GETCOLLISIONSDF Gets the amount of collisions between a set of voxels in both count and summed internal distance, given voxel coordinates Nx3 matrix, and a Nx4 matrix defining the SDF values at the meshgrid coordinates
%   Detailed explanation goes here
sdfValuesAtVoxels = interp3(sdfGrid(:,1),sdfGrid(:,2),sdfGrid(:,3),sdfGrid(:,4),objectVox(:,1),objectVox(:,2),objectVox(:,3),method);
%% Filter by only inside
sdfValuesAtVoxels = sdfValuesAtVoxels(sdfValuesAtVoxels<0);
%% Count and sum
countCollide = length(sdfValuesAtVoxels);
summedCollide = sum(sdfValuesAtVoxels);
end

