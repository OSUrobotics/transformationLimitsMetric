function [ verticesOut ] = rotateMesh( verticesIn, normalVector, theta, centroid )
%%ROTATEMESH Rotates the mesh vertices about the normal vector theta degrees
%   Takes a center point for the mesh, or if missing takes the center of
%   the bounding box surounding the mesh, and rotates the object about that
%   point on the line going through the normal vector (if trying to
%   rotate a cube, and normal vector is straight up, turns side to side).
%% Standardizing passed in contents if not in desired format
if nargin == 3 % if there isn't a given center, make it the bounding box center
    centroid = getCentroidMesh(verticesIn);
end
normalVector = normalVector/norm(normalVector); % convert the normal vector into a unit vector
%% Conditionally either rotate or move, rotate, and move the points
if centroid == 0 % if don't need to relocate center to origin before rotating
    verticesOut = quatrotate([sind(theta/2),normalVector(:)'],verticesIn); % apply the quaternion rotation
else % if center and origin don't overlap
    verticesIn = bsxfun(@minus,verticesIn,centroid); % move center to origin and transpose matrix
%     figure;
%     scatter3(verticesIn(:,1),verticesIn(:,2),verticesIn(:,3)); % test the values in
    verticesOut = quatrotate([sind(theta/2),normalVector(:)'],verticesIn); % apply the quaternion rotation
    verticesOut = bsxfun(@plus,verticesOut,centroid); % move center back to original place
end
% figure;
% scatter3(verticesOut(:,1),verticesOut(:,2),verticesOut(:,3)); % test the result out
end