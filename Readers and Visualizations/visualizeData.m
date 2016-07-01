% function [ output_args ] = visualizeData( input_args )
clear, clf, close all;
path2object = 'BallOut.ply';
path2hand = 'roboHand.stl';
numSteps = 1:9;
collisionThreshold = 0.01;
objectScaleFactor = 5;
handScaleFactor = 15;
dataFilePath = 'Output/S%iAreaIntersection.csv';

%% Load the object and scale to origin
[objectV,objectF] = read_ply(path2object); % Gives vertical vertices matrix,association matrix
objectVpad = [objectV ones(size(objectV,1),1)]; % Pad the points list with ones to work with 4x4 transformation matrices
objectVpad = objectVpad*(makehgtform('translate',-getCentroidMesh(objectV)).'); % Translate the object to origin
objectVpad = objectVpad*(makehgtform('scale',objectScaleFactor/max(abs(objectV(:)))).'); % Scale the object to one,then to the scaleFactor inputted
%% Load the hand and scale to origin
[handV,handF,~,~] = stlRead(path2hand); % Same as above
handVpad = [handV ones(size(handV,1),1)];
handVpad = handVpad*(makehgtform('translate',-getCentroidMesh(handV)).');
handVpad = handVpad*(makehgtform('scale',handScaleFactor/max(abs(handV(:)))).');
handV = handVpad(:,1:3);
disp('Loaded and scaled objects');
%% Read data and assign to matrix
for step = numSteps
    fromTable = readtable(sprintf(dataFilePath,step));
    data = table2array(fromTable);
    transformations(:,:,step) = data(:,2:9);
end
disp('Filtered and realigned transformations');
%% Transform and plot
for transformIndex = 1:size(transformations,1)
    transformationStep = permute(transformations(transformIndex,:,:),[3 2 1]);
    ptsOut = [];
    for step = 1:size(transformationStep,1)
        if transformationStep(step,8) <= collisionThreshold
            %% Make the transformation matrix
            transformationMatrix = eye(4);
            transformationMatrix = (makehgtform('translate',transformationStep(step,1:3))*transformationMatrix).';
            transformationMatrix(1:3,1:3) = quat2dcm(transformationStep(step,4:7));
            ptsOut(:,:,step) = objectVpad*transformationMatrix;
        else
            break
        end
    end
    if size(ptsOut,3) > 1
        visualizeTransformations(ptsOut(:,1:3,:));
        hold on
    end
end
disp('Plotted');
stlPlot(handV,handF);
axis image;
camlight('headlight');
material('dull');
disp('Done');
% end