tic;
path2object = 'BallOut.ply';
path2hand = 'roboHand.stl';

objectScaleFactor = 5;
handScaleFactor = 15;

stepsToSearch = 1;
collisionThreshold = 0.01;

clf;
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
tran = [];
for step = stepsToSearch
    fromTable = readtable(sprintf('Output/S%iAreaIntersection.csv',step));
    data = table2array(fromTable);
    condition = data(:,9)<collisionThreshold;
    data(condition, :) = [];
    tran = [tran; data];
end
hold on;
for transform = 1:size(tran,1)
    %tic;
    %vox = getVoxelisedVerts(objectV,objectF,1);
    obj2draw = objectV * (quatrotate(tran(transform,5:8),eye(3)).');
    obj2draw = translateMesh(obj2draw,[tran(transform,2),tran(transform,3),tran(transform,4)]);
    %vox = vox * (quatrotate(tran(transform,5:8),eye(3)).');
    %vox = translateMesh(vox,[tran(transform,2),tran(transform,3),tran(transform,4)]);
    stlPlot(obj2draw,objectF,false);
    %scatter3(vox(:,1),vox(:,2),vox(:,3), '.r');
    %toc;
end
stlPlot(handV,handF,false,'Object & Hand');
camlight('headlight');
material('dull');
toc;
view(-50,30)