function [ percentages ] = getCollisionValues( meshAVerts, meshAVoxels, meshBVerts, meshBFaces, resolution, pmDepth, pmScale )
%GETCOLLISIONVALUES Summary of this function goes here
%   Detailed explanation goes here

%Loop through all steps and return collision values
for i = 1:size(meshAVerts, 3)
    percentages(1,i) = getPercentCollisionWithVerts(meshAVerts(:,:,i),meshAVoxels(:,:,i),meshBVerts,meshBFaces,resolution,pmDepth,pmScale)
end
end

