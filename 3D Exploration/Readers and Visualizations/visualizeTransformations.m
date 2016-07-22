function visualizeTransformations( object, subject, grasp, extreme, scaleAxes, collisionThreshhold, values2plot )
%% VISUALIZETRANSFORMATIONS 
%% Load the transformations
load('transformationStored.mat');
transformationMatrices = transformationStruct.trajectorySteps;
%% Get the filenames out
[objectTransformationFilepath,objectFilepath,surfaceFilepath,handFilepath,outputFPs] = filenamesFromComponents(object,subject,grasp,extreme,1:transformationStruct.numInterpolationSteps);
%% If no scaleAxes value, set default
if nargin < 5
    scaleAxes = 0.1;
end
if nargin < 6
    collisionThreshhold = 1;
end
%% If no values2plot, assign defaultly to all
if nargin < 7
    values2plot = 1:size(transformationStruct.values,2);
end
%% Load object and hand and link
[objectV, ~] = stlRead(objectFilepath);
[objectSurfV, ~] = read_ply(surfaceFilepath);
[handV,handF,~,objectSurfV] = loadHandObject(handFilepath, -[0 0 0.085/2+0.08], objectTransformationFilepath, objectV, objectSurfV, 0.385);
%% Plot the hand
% stlPlot(handV,handF);
%% Apply the transformation
objectVout = applySavedTransformations(transformationMatrices,objectSurfV,true);
disp('transformation applied');
%% Make a colormap
cmap = autumn(transformationStruct.numInterpolationSteps);    
%% Plot the arrows
for valueIndex = values2plot
   % plotAxesArrows(transformationMatrices(:,:,:,valueIndex),scaleAxes);
end
%% Loop through steps
for stepIndex = 1:transformationStruct.numInterpolationSteps-1
    %% Load the output files 
    outputStepData = table2array(readtable(outputFPs{stepIndex}));
    values2plotcurrent = values2plot;
    %% Loop through values
    for valueIndex = values2plotcurrent
        if outputStepData(valueIndex,8) <= collisionThreshhold
            plot3(objectVout(:,1,stepIndex,valueIndex),objectVout(:,2,stepIndex,valueIndex),objectVout(:,3,stepIndex,valueIndex),'.','MarkerEdgeColor',cmap(stepIndex,:));
            hold on;
        else %% If not meeting the threshold, remove that value from the list, making it deadend at that point
            values2plot(values2plot == valueIndex) = [];
        end
    end
end
addLight;
end