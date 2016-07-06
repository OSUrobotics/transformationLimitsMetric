tic;
%RUNSIMULATION Creates data representing a grasp
%   Loads an object PLY file, a pre-positioned hand STL, and some settings 
%   and returns the area overlap of the two objects at evenly distributed 
%   transformations.
%% Declare variables and start parallel pool
try
    parpool(7);
catch er
    disp('Looks like someone tried to start a parallel pool when there was one already running');
end
path2object = 'BallOut.ply';
path2hand = 'roboHand.stl';
objectScaleFactor = 5;
handScaleFactor = 15;
transformationScaleFactor = 20;
numDirectionPoints = 20;
numOrientationPoints = 15;
angleDistribution = 10;
interpolationNumber = 10;
voxelResolution = 5;
pmDepth = 4;
pmScale = 1;
transformationsFilename = 'transformationStored';
outputFilePath = 'Output/S%iAreaIntersection.csv';
tableHeaders = {'X_Translation','Y_Translation','Z_Translation','Axis_X','Axis_Y','Axis_Z','Angle_Rotated','Percent_Volume_Intersection'};
disp('Started Script');
%% If not already loaded, load the transformation values
if ~exist('transformationStruct','var')
    %% If not already created, create the file
    if ~exist(transformationsFilename,'file')
        transformationStruct = saveTrajectories(numDirectionPoints,numOrientationPoints,angleDistribution,interpolationNumber,transformationScaleFactor,transformationsFilename);
    else
        load(transformationsFilename);
    end
end
disp('Generated/loaded transformations');
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
disp('Loaded and scaled objects');
%% Display the hand and object
clf;
stlPlot(objectV,objectF,true);
stlPlot(handV,handF,true,'Object & Hand');
scatter3(objectVox(:,1),objectVox(:,2),objectVox(:,3), '.r');
camlight('headlight');
material('dull');
%% Apply the saved transformations to the voxels and vertices
ptsOut = applySavedTransformations(transformationStruct.trajectorySteps,objectV,true);
voxOut = applySavedTransformations(transformationStruct.trajectorySteps,objectVox,true);
disp('Applied transformations');
%% Get the amount of volume intersection
volumeIntersecting = zeros(size(transformationStruct.values,2),transformationStruct.numInterpolationSteps);
numValues = size(transformationStruct.values,2);
for stepIndex = 1:transformationStruct.numInterpolationSteps
    parfor valueIndex = 1:numValues
        volumeIntersecting(valueIndex,stepIndex) = getPercentCollisionWithVerts(ptsOut(:,:,stepIndex,valueIndex),voxOut(:,:,stepIndex,valueIndex),handV,handF,voxelResolution,pmDepth,pmScale);
        fprintf('Calculated volume intersection for set #%i/%i\n',valueIndex,numValues);
    end
end
%% Concatenate with the step values
outputMatrix = [transformationStruct.stepValues; permute(volumeIntersecting,[3 1 2])];
%% Remap output to timestamp pages
outputMatrix = permute(outputMatrix,[2 1 3]);
%% Save to file
for i = 2:size(outputMatrix,3)
    outputTable = array2table(outputMatrix(:,:,i), 'VariableNames', tableHeaders);
    writetable(outputTable, sprintf(outputFilePath,i-1));
    fprintf('File written for time %i\n',i-1);
end
%% End of script, kill parallel pool
p = gcp;
delete(p);
disp('Done with script');
toc;