function [ handV, handF, objectV, objectF ] = loadHandObject( handFilepath, objectTransformationFilepath, objectFilepath, handSpreadDistance, sphereRadius, handRelativeCenter )
%% LOADHANDOBJECT Normalizes an inputed grasp system
%==========================================================================
%
% USAGE
%       [ handV, handF, objectV, objectF ] = loadHandObject( handFilepath, objectTransformationFilepath, objectFilepath, handSpreadDistance, sphereRadius, handRelativeCenter )
%
%       [ handV, handF, objectV, objectF ] = loadHandObject( handFilepath, objectTransformationFilepath, objectFilepath, handSpreadDistance, sphereRadius )
%
%       [ handV, handF, objectV, objectF ] = loadHandObject( handFilepath, objectTransformationFilepath, objectFilepath, handSpreadDistance )
%
% INPUTS
%
%       handFilepath                    - Mandatory - Filepath String   - Path to the hand STL file
%
%       objectTransformationFilepath    - Mandatory - Filepath String   - Path to the object transformation matrix csv from OpenRave 
%
%       objectFilepath                  - Mandatory - Filepath String   - Path to the PolyMended ply file
%
%       handSpreadDistance              - Mandatory - Double Value      - Distance between fingertips at the largest possible reach of the hand
%
%       sphereRadius                    - Optional  - Double Value      - Radius of the sphere to normalize to.  Defaults to 1 when given no argument
%
%       handRelativeCenter              - Optional  - 1x3 Vector        - Offset from hand origin to center of grasp.  Calculates from handSpreadDistance when given no argument
%
% OUTPUTS
%
%       handV                           - Mandatory - Nx3 Array         - Vertex data of the hand where N is the number of vertices
%
%       handF                           - Mandatory - Nx3 Array         - Face data of the hand where N is the number of faces
%
%       objectV                         - Mandatory - Nx3 Array         - Vertex data of the object where N is the number of vertices
%
%       objectF                         - Mandatory - Nx3 Array         - Face data of the object where N is the number of faces
%
% EXAMPLE
%
%       To get the normalized hand and object of a grasp system w/ a BH8-280 and a pitcher:
%       >>  [ handV, handF, objectV, objectF ] = loadHandObject( pathToBH8-280, pathToTransformationMatrix, pathToPolyMendedPitcher, 0.385 )
%
% NOTES
%
%   -The stls for both the hand and the object must have come out of OpenRave.
%   -The object must then be put through PolyMender, and passed as a ply file. 
%    must match the arguments used.
%   -handSpreadDistance can be measured or gotten from the hand's datasheet.
%
%==========================================================================

%% Read in data
[handV, handF] = stlRead(handFilepath);
[objectV, objectF] = read_ply(objectFilepath);
transformationMatrix = csvread(objectTransformationFilepath);
objectV = (transformationMatrix*(objectV.')).';
%% Calculate relative center if none given
if nargin <= 5
    handRelativeCenter = [0 0 handSpreadDistance/(2*pi)]; 
end
if nargin == 4
    sphereRadius = 1;
end
%% Transform object and hand to new center
objectV = objectV - repmat(handRelativeCenter,[size(objectV,1) 1]);
handV = handV - repmat(handRelativeCenter,[size(handV,1) 1]);

%% Define a scale matrix based on the ratio of sphere cross section diameter over handSpreadDistance
transformationMatrix = makehgtform('scale', ...
                      (2*sqrt(sphereRadius^2-handRelativeCenter(3)^2)) / ...
                       handSpreadDistance);
%% Apply scale transformation
objectV = (transformationMatrix*(objectV.')).';
handV = (transformationMatrix*(handV.')).';
end