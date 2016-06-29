function [ output_args ] = runSimulation( path2object, path2hand, objectScaleFactor, handScaleFactor, directionPoints, orientationPoints, angleDistribution, interpolationNumber)
%RUNSIMULATION loads an object STL file, a pre-positioned hand STL, and some settings and returns the area overlap of the two objects at evenly distributed transformations 
%% Load the object and scale to origin
[objectV,objectF,~,~] = stlRead(path2object); % Gives vertical vertices matrix,association matrix
objectVpad = [objectV ones(size(objectV,1),1)]; % Pad the points list with ones to work with 4x4 transformation matrices
objectVpad = makehgtform('translate',-getCentroidMesh(objectV)).'*objectVpad; % Translate the object to origin
objectVpad = makehgtform('scale',objectScaleFactor/max(abs(objectV(:)))).'*objectVpad; % Scale the object to one,then to the scaleFactor inputted
objectV = objectVpad(1:3,:); % Remove padding
%% Load the hand and scale to origin
[handV,handF,~,~] = stlRead(path2hand); % Same as above
handVpad = [handV ones(size(handV,1),1)];
handVpad = makehgtform('translate',-getCentroidMesh(handV)).'*handVpad;
handVpad = makehgtform('scale',handScaleFactor/max(abs(handV(:)))).'*handVpad;
handV = handVpad(1:3,:);
%% Generate transformation directions and orientations
transformationValues = makeTransformationValues(directionPoints,orientationPoints,angleDistribution); % Use the function to generate the matrix of combinations
%% Loop through and render on the plot
clf;
for values = transformationValues
    [ptsOut,positionTransformsVector,positionTransformsMatrix] = eulerIntegration3dFromValues(values,objectV,interpolationNumber,1);
    visualizeTransformations(ptsOut);
end
axis image
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
end

