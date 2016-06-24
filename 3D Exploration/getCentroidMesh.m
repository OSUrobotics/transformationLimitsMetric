function [ centroidPoint] = getCentroidMesh( pointList )
%GETCENTERMESH Gets the point to transform about, given a vertices matrix.
%   Takes the outermost points of the mesh and averages them to get the
%   center of the bounding cube surounding the object.
centroidPoint = [mean(pointList(:,1)),mean(pointList(:,2)),mean(pointList(:,3))];
end

