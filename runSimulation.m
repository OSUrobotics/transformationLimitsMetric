%RUNSIMULATION Creates data representing a grasp
%   Loads an object PLY file, a pre-positioned hand STL, and some settings 
%   and returns the area overlap of the two objects at evenly distributed 
%   transformations.
%% Declare variables and start parallel pool
parpool(4);
path2object = 'BallOut.ply';
path2hand = 'roboHand.stl';
objectScaleFactor = 5;
handScaleFactor = 15;
transformationScaleFactor = 20;
numDirectionPoints = 10;
numOrientationPoints = 10;
angleDistribution = 5;
interpolationNumber = 10;
voxelResolution = 0.5;
pmDepth = 4;
pmScale = 1;
outputFilePath = 'Output/S%iAreaIntersection.csv';
tableHeaders = {'Timestamp','X_Translation','Y_Translation','Z_Translation','Quaternion_Value_1','Quaternion_Value_2','Quaternion_Value_3','Quaternion_Value_4','Percent_Volume_Intersection'};
disp('Started Script');
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
camlight('headlight');
material('dull');
%% Generate transformation directions and orientations
transformationValues = makeTransformationValues(numDirectionPoints,numOrientationPoints,angleDistribution); % Use the function to generate the matrix of combinations
%% Loop through and render on the plot
%clf;
outputMatrix = zeros(interpolationNumber,9,size(transformationValues, 2));
tic;
lengthValues = size(transformationValues, 2);
% bar = waitbar(0,'Starting Loop...','Name','Running Grasp Simulation...');
parfor valueIndex = 1:lengthValues % For every combination of values
    %% Transform to all locations
    values = transformationValues(:,valueIndex); % Get the set of values
    [ptsOut,positionTransformsVector,~] = eulerIntegration3dFromValues(values,objectV,interpolationNumber,transformationScaleFactor); % Transform the object to each step
    [voxOut,~,~] = eulerIntegration3dFromValues(values,objectVox,interpolationNumber,transformationScaleFactor); % Transform voxels as well
    %% Volume of intersection
    percentages = zeros(1,interpolationNumber); % Preallocate
    for i = 1:size(ptsOut, 3) % For every step, get the percent collision and add it to percentages
        percentages(i) = getPercentCollisionWithVerts(ptsOut(:,:,i),voxOut(:,:,i),handV,handF,voxelResolution,pmDepth,pmScale);
    end
    %% Write to matrix
    outputMatrix(:,:,valueIndex) = [((1:interpolationNumber)-1).' positionTransformsVector.' percentages(1:interpolationNumber).'];
    %% Update the loading bar
    fprintf('Done with value set %i/%i\n',valueIndex,lengthValues);
    % waitbar(valueIndex / size(transformationValues, 2),bar,sprintf('Simulating... (%i/%i)', valueIndex,size(transformationValues,2)));
end
%% End the timer and progressbar
disp('Done looping');
toc;
%% Remap output to timestamp pages
outputMatrix = permute(outputMatrix,[3 2 1]);
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