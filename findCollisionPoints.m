path2object = 'BallOut.ply';
path2hand = 'roboHand.stl';

stepsToSearch = 1:9;
collisionThreshold = 0.1;

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
%% 
transformations = [];
for step = stepsToSearch
    fromTable = readtable(sprintf('Output/S%iAreaIntersection.csv',step));
    data = table2array(fromTable);
    condition = data(:,9)<collisionThreshold;
    data(condition, :) = 0;
    transformations(:,:,step) = data;
end

for transform = 1:size(transformations,1)
    transformationSteps = transformations(transform,:,:)
    if(transformationSteps ~= 0)
        
    end
end