function [ handV, handF, objectV, objectSurf ] = loadHandObject( handFilepath, originToCenterVector, transformationFilepath, objectV, objectSurf, handSpreadDistance, sphereRadius )
%% LOADHANDOBJECT Normalizes an inputed grasp system
%==========================================================================
%
% USAGE
%
%       [ handV, handF, objectV, objectSurf ] = loadHandObject( handFilepath, originToCenterVector, objectTransformationFilepath, objectV, objectSurf, handSpreadDistance, sphereRadius, handRelativeCenter )
%
% INPUTS
%
%       handFilepath                    - Mandatory - Filepath String   - Path to the hand STL file
%
%       originToCenterVector            - Mandatory - 1x3 Vector        - Vector from the hand's origin to the center of its grasp
%
%       transformationFilepath          - Mandatory - Filepath String   - Path to the transformation matrices file from OpenRave 
%
%       objectV                         - Mandatory - Nx3 Matrix        - List of vertices where N is the number of points in the mesh
%
%       objectSurf                      - Mandatory - Nx3 Matrix        - List of vertices where N is the number of poisson sampled points from the meshLab mesh
%
%       handSpreadDistance              - Mandatory - Double Value      - Distance between fingertips at the largest possible reach of the hand
%
%       sphereRadius                    - Optional  - Double Value      - Radius of the sphere to normalize to.  Defaults to 1 when given no argument
%
% OUTPUTS
%
%       handV                           - Mandatory - Nx3 Array         - Vertex data of the hand where N is the number of vertices
%
%       handF                           - Mandatory - Nx3 Array         - Face data of the hand where N is the number of faces
%
%       objectV                         - Mandatory - Nx3 Array         - Vertex data of the object where N is the number of vertices
%
%       objectSurf                      - Mandatory - Nx3 Array         - Surface samples of the object where N is the number of points
%
% EXAMPLE
%
%       To get the normalized hand and object of a grasp system w/ a BH8-280 and a pitcher:
%       >>  [ handV, handF, objectV ] = loadHandObject( pathToBH8-280,[0,0,-0.08] ,pathToTransformationMatrix, pitcherVerts, pitcherSurfSamples, 0.385 )
%
% NOTES
%
%   -The stls for both the hand and the object must have come out of OpenRave.
%   -The object must then be put through meshLab, and exported as a ply file containing the poisson-disk sampled points of the object. 
%   -handSpreadDistance can be measured or gotten from the hand's datasheet.
%
%==========================================================================

%% Read in data
[handV, handF] = stlRead(handFilepath);
handV(:,4) = 1;
objectV(:,4) = 1;
objectV = objectV * makehgtform('scale',0.001).';
objectSurf(:,4) = 1;
objectSurf = objectSurf * makehgtform('scale',0.001).';
% Read file in
textIn = fileread(transformationFilepath);
% Remove pesky brackets
textIn = regexprep(textIn,'[',' ');
textIn = regexprep(textIn,']',' ');
% Split into an array of values
splitStrings = strsplit(textIn);
splitStrings = str2double(splitStrings);
% Reshape into proper transformation matrices
transformationMatrix = reshape(splitStrings(2:17), [4,4]).';
handTransformationMatrix = reshape(splitStrings(19:34), [4,4]).';
%% Create object transformation matrix and translate object
transformationMatrix = handTransformationMatrix \ transformationMatrix;
objectV = (transformationMatrix*((objectV.'))).';
objectSurf = (transformationMatrix*((objectSurf.'))).';
%% Move system so palm is in correct location
objectV = objectV * makehgtform('translate',originToCenterVector).';
objectSurf = objectSurf * makehgtform('translate',originToCenterVector).';
handV = handV * makehgtform('translate',originToCenterVector).';
%% If no sphereRadius, make it be 1 by default
if nargin < 7
    sphereRadius = 1;
end
%% Define a scale matrix based on the ratio of sphere cross section diameter over handSpreadDistance
transformationMatrix = makehgtform('scale', ...
                      (2*sqrt(sphereRadius^2-originToCenterVector(3)^2)) / ...
                       handSpreadDistance);
%% Apply scale transformation
objectV = (transformationMatrix*(objectV.')).';
objectSurf = (transformationMatrix*(objectSurf.')).';
handV = (transformationMatrix*(handV.')).';
handV = handV(:,1:3);
objectV = objectV(:,1:3);
objectSurf = objectSurf(:,1:3);
end