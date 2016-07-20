function visualizeTransformations( object, subject, grasp, extreme, scaleAxes, collisionThreshhold )
%% VISUALIZETRANSFORMATIONS 
%% Load the transformations
load('transformationStored.mat');
transformationMatrices = transformationStruct.trajectorySteps;
%% Get the filenames out
[objectTransformationFilepath,objectFilepath,surfaceFilepath,handFilepath,outputFP] = filenamesFromComponents(object,subject,grasp,extreme,1:transformationStruct.numInterpolationSteps);
%% If no scaleAxes value, set default
if nargin < 6
    scaleAxes = 0.1;
end
%% Load object and hand and link
[objectV, ~] = stlRead(objectFilepath);
[objectSurfV, ~] = read_ply(surfaceFilepath);
[handV,handF,~,objectSurfV] = loadHandObject(handFilepath, -[0 0 0.085/2+0.08], objectTransformationFilepath, objectV, objectSurfV, 0.385);
%% Plot the hand
stlPlot(handV,handF);
%% Apply the transformation
objectVout = applySavedTransformations(transformationMatrices,objectSurfV,true);
disp('transformation applied');
%% Make a colormap
cmap = summer(size(objectVout,3));
%% Loop through values
for valueIndex = 1:size(objectVout,4)
    %% Plot the arrows
    plotAxesArrows(transformationMatrices(:,:,:,valueIndex),scaleAxes);
    %% Loop through steps
    for stepIndex = 1:size(objectVout,3)
        plot3(objectVout(:,1,stepIndex,valueIndex),objectVout(:,2,stepIndex,valueIndex),objectVout(:,3,stepIndex,valueIndex),'.','MarkerEdgeColor',cmap(stepIndex,:));
    end
end
end