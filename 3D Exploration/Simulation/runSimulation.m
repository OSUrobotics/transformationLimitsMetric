path2object = '';
path2hand = '';
objectScaleFactor = 0.5;
handScaleFactor = 1;
transformationScaleFactor = 1.5;
numDirectionPoints = 50;
numOrientationPoints = 25;
angleDistribution = 10;
interpolationNumber = 10;
voxelResolution = 0.5;
pmDepth = 8;
pmScale = 1;
outputFile = 'Out.mat';
%RUNSIMULATION loads an object PLY file, a pre-positioned hand STL, and some settings and returns the area overlap of the two objects at evenly distributed transformations 
%% Load the object and scale to origin
[objectV,objectF] = read_ply(path2object); % Gives vertical vertices matrix,association matrix
objectVpad = [objectV ones(size(objectV,1),1)]; % Pad the points list with ones to work with 4x4 transformation matrices
objectVpad = makehgtform('translate',-getCentroidMesh(objectV)).'*objectVpad; % Translate the object to origin
objectVpad = makehgtform('scale',objectScaleFactor/max(abs(objectV(:)))).'*objectVpad; % Scale the object to one,then to the scaleFactor inputted
objectV = objectVpad(1:3,:); % Remove padding
objectVox = getVoxelisedVerts(objectV,objectF,voxelResolution);
%% Load the hand and scale to origin
[handV,handF,~,~] = stlRead(path2hand); % Same as above
handVpad = [handV ones(size(handV,1),1)];
handVpad = makehgtform('translate',-getCentroidMesh(handV)).'*handVpad;
handVpad = makehgtform('scale',handScaleFactor/max(abs(handV(:)))).'*handVpad;
handV = handVpad(1:3,:);
%% Generate transformation directions and orientations
transformationValues = makeTransformationValues(numDirectionPoints,numOrientationPoints,angleDistribution); % Use the function to generate the matrix of combinations
%% Loop through and render on the plot
clf;

outputArray = zeros(interpolationNumber,8,size(transformationValues, 2));
for valueIndex = 1:size(transformationValues, 2)
    values = transformationValues(:,valueIndex);
    [ptsOut,positionTransformsVector,positionTransformsMatrix] = eulerIntegration3dFromValues(values,objectV,interpolationNumber,1);
    visualizeTransformations(ptsOut);
    %Access ptsOut as (pointNumber, axis, step)
    [voxOut,~,~] = eulerIntegration3dFromValues(values,objectVox,interpolationNumber,1);
    percentages = getCollisionValues(ptsOut,voxOut,handV,handF,voxelResolution,pmDepth,pmScale);
    for i = 1:interpolationNumber
        outputArray(i,:,valueIndex) = [positionTransformsVector(:,i) percentages(i)];
    end    
end
%Write outputArray... somehow.
axis image
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
