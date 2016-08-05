function visualizeTransformations( object, subject, grasp, extreme, values2plot, scaleAxes, collisionThreshold )
%% VISUALIZETRANSFORMATIONS
%==========================================================================
%
% USAGE
%
%       visualizeTransformations( object, subject, grasp, extreme, scaleAxes, collisionThreshold, values2plot )
%
% INPUTS
%
%       object              - Mandatory - Integer Value     - The object number, used with the other 3 values to select a set of data to display
%
%       subject             - Mandatory - Integer Value     - The subject number, used with the other 3 values to select a set of data to display
%
%       grasp               - Mandatory - Integer Value     - The grasp number, used with the other 3 values to select a set of data to display
%
%       extreme             - Mandatory - String            - The "extreme#" or "optimal#" string built into the filepath, used with the other 3 values to select a set of data to display
%
%       values2plot         - Optional  - Integer Vector    - A range of values (directions and orientations specified in transformationStored) to plot
%
%       scaleAxes           - Optional  - Double Value      - The scalar applied to the length of the arrows that make up the axes indicators. If axes display is not wanted, set to 0, defaults to 0.15
%
%       collisionThreshold  - Optional  - Double Value      - Hide the steps where the collision volume exceeds this value
%
% EXAMPLE
%
%       Plot the 63rd, 113th, and 185th values of the object 15, subject 5, grasp 1 extreme0_target dataset, with no axes and a threshold of 0.00003
%       visualizeTransformations(15,6,1,'extreme0_target',[63 113 185],0,0.00003);
%
%==========================================================================
%% Load the transformations
load('transformationStored.mat');
transformationMatrices = transformationStruct.trajectorySteps;
%% Get the filenames out
[objectTransformationFilepath,objectFilepath,surfaceFilepath,handFilepath,outputFPs] = filenamesFromComponents(object,subject,grasp,extreme,1:transformationStruct.numInterpolationSteps);
%% By default, display all transformation values (Probably will crash if try to save it)
if nargin < 5
    values2plot = 1:size(transformationStruct.values,2);
end
%% By default, set axis scale to 0.15
if nargin < 6
    scaleAxes = 0.15;
end
%% By default, display all steps
if nargin < 7
    collisionThreshold = 1;
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
cmap = autumn(transformationStruct.numInterpolationSteps);    
%% Plot the arrows if want that
if scaleAxes ~= 0
    for valueIndex = values2plot
       plotAxesArrows(transformationMatrices(:,:,:,valueIndex),scaleAxes);
    end
end
%% Loop through steps
for stepIndex = 1:transformationStruct.numInterpolationSteps-1
    %% Load the output files 
    outputStepData = table2array(readtable(outputFPs{stepIndex}));
    values2plotcurrent = values2plot;
    %% Loop through values
    for valueIndex = values2plotcurrent
        if outputStepData(valueIndex,8) <= collisionThreshold
            plot3(objectVout(:,1,stepIndex,valueIndex),objectVout(:,2,stepIndex,valueIndex),objectVout(:,3,stepIndex,valueIndex),'.','MarkerEdgeColor',cmap(stepIndex,:));
            hold on;
        else %% If not meeting the threshold, remove that value from the list, making it deadend at that point
            values2plot(values2plot == valueIndex) = [];
        end
    end
end
%% Improve display
axis image;
addLight;
end