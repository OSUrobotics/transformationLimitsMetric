function [ handV, handF, objectV, objectF ] = loadHandObject( handFilepath, originToPalmVector, transformationFilepath, objectFilepath, handSpreadDistance, sphereRadius, handRelativeCenter )
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
%       originToPalmVector              - Mandatory - 1x3 Vector        - Vector from the hand's origin to the center of its palm
%
%       transformationFilepath          - Mandatory - Filepath String   - Path to the transformation matrices file from OpenRave 
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
handV(:,4) = 1;
fileType = objectFilepath(end - 3:end);
if(strcmpi(fileType, '.stl'))
    [objectV, objectF] = stlRead(objectFilepath);
    disp('Loading STL file.');
    warning('WARNING:  A PolyMended PLY file should be used for actual simulations');
elseif(strcmpi(fileType, '.ply'))
    [objectV, objectF] = read_ply(objectFilepath);
    disp('Loading PLY file');
else
    error('INVALID OBJECT:  Object filepath does not point to an STL or PLY');
end
objectV(:,4) = 1;
objectV = objectV * makehgtform('scale',0.001).';
% objectV = objectV * makehgtform('translate',0,0,-0.08).';
% handV = handV * makehgtform('translate',0,0,0.08).';
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
%% Calculate relative center if none given
if nargin <= 6
    handRelativeCenter = [0 0 handSpreadDistance/(2*pi) 1]; 
end
if nargin == 5
    sphereRadius = 1;
end
%% Define a scale matrix based on the ratio of sphere cross section diameter over handSpreadDistance
transformationMatrix = makehgtform('scale', ...
                      (2*sqrt(sphereRadius^2-handRelativeCenter(3)^2)) / ...
                       handSpreadDistance);
%% Apply scale transformation
objectV = (transformationMatrix*(objectV.')).';
handV = (transformationMatrix*(handV.')).';
%% Transform object and hand to new center
objectV = objectV - repmat(handRelativeCenter,[size(objectV,1) 1]);
handV = handV - repmat(handRelativeCenter,[size(handV,1) 1]);
%% Move system so palm is in correct location
objectV = objectV * makehgtform('translate',originToPalmVector);
handV = handV * makehgtform('translate',originToPalmVector);
handV = handV(:,1:3);
objectV = objectV(:,1:3);
end