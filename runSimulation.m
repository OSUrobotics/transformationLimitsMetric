path2object = 'PitcherAssmMTest.ply';
path2hand = 'roboHand.stl';
objectScaleFactor = 5;
handScaleFactor = 15;
transformationScaleFactor = 20;
numDirectionPoints = 20;
numOrientationPoints = 15;
angleDistribution = 10;
interpolationNumber = 10;
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
tic;
for valueIndex = 1:size(transformationValues, 2) % For every combination of values
    values = transformationValues(:,valueIndex); % Get the set of values
    [ptsOut,positionTransformsVector,~] = eulerIntegration3dFromValues(values,objectV,interpolationNumber,transformationScaleFactor); % Transform the object to each step
    %visualizeTransformations(ptsOut, objectF);
    [voxOut,~,~] = eulerIntegration3dFromValues(values,objectVox,interpolationNumber,transformationScaleFactor); % Transform voxels as well
    percentages = zeros(1,size(ptsOut,3)); % Preallocate
    for i = 1:size(ptsOut, 3) % For every step, get the percent collision and add it to percentages
        percentages(i) = getPercentCollisionWithVerts(ptsOut(:,:,i),voxOut(:,:,i),handV,handF,voxelResolution,pmDepth,pmScale);
    end
    for i = 1:interpolationNumber % For every step, add the values to the output array
        outputArray(i,:,valueIndex) = [i positionTransformsVector(:,i).' percentages(i)];
    end
    %Update the loading bar
    waitbar(valueIndex / size(transformationValues, 2),bar,sprintf('Simulating... (%i/%i)', valueIndex,size(transformationValues,2)));
end
toc;
close(bar);
%Write outputArray... somehow.
axis image
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
