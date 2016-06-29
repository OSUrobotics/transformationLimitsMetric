function [ verticesOut ] = translateMesh( verticesIn, directionVector, distanceTransform )
%%TRANSLATEMESH Move the mesh along the directional vector a certain distance or the length of the vector
%   Translates the mesh relative to current location
if nargin == 3
    directionVector = directionVector/norm(directionVector)*distanceTransform;
end
verticesOut = bsxfun(@plus,verticesIn,directionVector);
end

