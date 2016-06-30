path2object = 'BallOut.ply';
path2hand = 'roboHand.stl';
objectScaleFactor = 5;
handScaleFactor = 15;
transformationScaleFactor = 20;
numDirectionPoints = 10;
numOrientationPoints = 5;
angleDistribution = 5;
interpolationNumber = 3;
voxelResolution = 0.5;
pmDepth = 4;
pmScale = 1;
outputFile = 'Out.mat';
%RUNSIMULATION loads an object PLY file, a pre-positioned hand STL, and some settings and returns the area overlap of the two objects at evenly distributed transformations 
bar = waitbar(0,'Starting Sumulation...','Name','Running Grasp Simulation...');
%% Load the object and scale to origin
[objectV,objectF] = read_ply(path2object); % Gives vertical vertices matrix,association matrix
objectVpad = [objectV ones(size(objectV,1),1)]; % Pad the points list with ones to work with 4x4 transformation matrices
objectVpad = objectVpad*(makehgtform('translate',-getCentroidMesh(objectV)).'); % Translate the object to origin
objectVpad = objectVpad*(makehgtform('scale',objectScaleFactor/max(abs(objectV(:)))).'); % Scale the object to one,then to the scaleFactor inputted
objectV = objectVpad(:,1:3); % Remove padding
objectVox = getVoxelisedVerts(objectV,objectF,voxelResolution);
%% Load the hand and scale to origin
[handV,handF,~,~] = stlRead(path2hand); % Same as above
handVpad = [handV ones(size(handV,1),1)];
handVpad = handVpad*(makehgtform('translate',-getCentroidMesh(handV)).');
handVpad = handVpad*(makehgtform('scale',handScaleFactor/max(abs(handV(:)))).');
handV = handVpad(:,1:3);
%% Generate transformation directions and orientations
stlPlot(objectV,objectF,true,'Object');
stlPlot(handV,handF,true,'Hand');
transformationValues = makeTransformationValues(numDirectionPoints,numOrientationPoints,angleDistribution); % Use the function to generate the matrix of combinations
%% Loop through and render on the plot
%clf;
outputArray = zeros(interpolationNumber,9,size(transformationValues, 2));
for valueIndex = 1:size(transformationValues, 2)
    tic;
    values = transformationValues(:,valueIndex);
    [ptsOut,positionTransformsVector,~] = eulerIntegration3dFromValues(values,objectV,interpolationNumber,transformationScaleFactor);
    %visualizeTransformations(ptsOut, objectF);
    %Access ptsOut as (pointNumber, axis, step)
    [voxOut,~,~] = eulerIntegration3dFromValues(values,objectVox,interpolationNumber,transformationScaleFactor);
    percentages = getCollisionValues(ptsOut,voxOut,handV,handF,voxelResolution,pmDepth,pmScale);
    for i = 1:interpolationNumber
        outputArray(i,:,valueIndex) = [i positionTransformsVector(:,i).' percentages(i)];
    end
    waitbar(valueIndex / size(transformationValues, 2),bar,'Simulating...');
    toc;
end
close(bar);
%Write outputArray... somehow.
axis image
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
