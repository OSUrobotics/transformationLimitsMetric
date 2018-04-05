function [ str ] = TagForTransformation( transformation )
%TagForTransformation Generate a string recording the transformation names
%   In this order

% transformationSettings.numTranslationDirections = 28;
% transformationSettings.numRotationAxes = 7;
% transformationSettings.angleDivisions = [-.5 0 .5];
% transformationSettings.numInterpolationSteps = 10;

str = ...
strcat( '_', num2str( transformation.numTranslationDirections ), ...
        '_', num2str( transformation.numRotationAxes ), ...
        '_', num2str( length( transformation.angleDivisions) ), ...
        '_', num2str( transformation.numInterpolationSteps ) );
end

