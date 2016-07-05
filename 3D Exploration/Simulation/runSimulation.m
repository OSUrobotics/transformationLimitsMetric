tic;
%RUNSIMULATION Creates data representing a grasp
%   Loads an object PLY file, a pre-positioned hand STL, and some settings 
%   and returns the area overlap of the two objects at evenly distributed 
%   transformations.
%% Declare variables and start parallel pool
p = gcp('nocreate');
if isempty(p)
    parpool(7);
end

path2object = 'PitcherAssmMTest.ply';
path2hand = 'roboHand.stl';
objectScaleFactor = 15;
handScaleFactor = 15;
transformationScaleFactor = 20;
numDirectionPoints = 20;
numOrientationPoints = 15;
angleDistribution = 10;
interpolationNumber = 10;
voxelResolution = 5;
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
%% Load the hand and scale to origin
[handV,handF,~,~] = stlRead(path2hand); % Same as above
handVpad = [handV ones(size(handV,1),1)];
handVpad = handVpad*(makehgtform('translate',-getCentroidMesh(handV)).');
handVpad = handVpad*(makehgtform('scale',handScaleFactor/max(abs(handV(:)))).');
handV = handVpad(:,1:3);
disp('Loaded and scaled objects');
%% Display the hand and object, then take edits from user
while 1
    clf;
    stlPlot(objectV,objectF,true);
    stlPlot(handV,handF,true,'Object & Hand');
    camlight('headlight');
    material('dull');
    in = input('Do you want to edit the object pos? Y/N [N]: ','s');
    if isempty(in)%Default to no if no input is given
        in = 'N';
    end
    if in == 'Y'
        %% Handle repositioning
        rotateXIn = input('X Rotate [0]: ');
        rotateYIn = input('Y Rotate [0]: ');
        rotateZIn = input('Z Rotate [0]: ');
        translateXIn = input('X Translate [0]: ');
        translateYIn = input('Y Translate [0]: ');
        translateZIn = input('Z Translate [0]: ');
        scaleXIn = input('X Scale [1]: ');
        scaleYIn = input('Y Scale [1]: ');
        scaleZIn = input('Z Scale [1]: ');
        %Apply default values
        if isempty(rotateXIn)
            rotateXIn = 0;
        end
        if isempty(rotateYIn)
            rotateYIn = 0;
        end
        if isempty(rotateZIn)
            rotateZIn = 0;
        end
        if isempty(translateXIn)
            translateXIn = 0;
        end
        if isempty(translateYIn)
            translateYIn = 0;
        end
        if isempty(translateZIn)
            translateZIn = 0;
        end
        if isempty(scaleXIn)
            scaleXIn = 1;
        end
        if isempty(scaleYIn)
            scaleYIn = 1;
        end
        if isempty(scaleZIn)
            scaleZIn = 1;
        end
        %Apply transformation to temporary meshes
        tempObjectV = objectVpad*(makehgtform(...
                      'translate',[translateXIn,translateYIn,translateZIn],...
                      'scale',[scaleXIn,scaleYIn,scaleZIn],...
                      'xrotate',deg2rad(rotateXIn),...
                      'yrotate',deg2rad(rotateYIn),...
                      'zrotate',deg2rad(rotateZIn)).');
        %Draw new positions
        tempObjectV = tempObjectV(:,1:3); % Remove padding
        clf;
        stlPlot(tempObjectV,objectF,true);
        stlPlot(handV,handF,true,'Is this OK?');
        camlight('headlight');
        material('dull');
        %Confirm
        in2 = input('Is this OK? Y/N [Y]: ','s');
        if isempty(in2)
            in2 = 'Y';
        end
        if in2 == 'Y'
            objectV = tempObjectV;
            disp('Here we go!');
            break;
        end
    elseif in ~= 'N'
        disp('Huh?');
    else
        disp('Continuing...');
        break;
    end    
end
%Generate Voxels
objectVox = getVoxelisedVerts(objectV,objectF,voxelResolution);
%% Generate transformation directions and orientations
transformationValues = makeTransformationValues(numDirectionPoints,numOrientationPoints,angleDistribution); % Use the function to generate the matrix of combinations
%% Loop through and render on the plot
%clf;
outputMatrix = zeros(interpolationNumber,9,size(transformationValues, 2));
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
%% Remap output to timestamp pages
outputMatrix = permute(outputMatrix,[3 2 1]);
%% Save to file
for i = 2:size(outputMatrix,3)
    outputTable = array2table(outputMatrix(:,:,i), 'VariableNames', tableHeaders);
    writetable(outputTable, sprintf(outputFilePath,i-1));
    fprintf('File written for time %i\n',i-1);
end
%% End of script, kill parallel pool
delete(p);
disp('Done with script');
toc;