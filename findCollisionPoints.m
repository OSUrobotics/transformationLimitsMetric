path2object = 'BallOut.ply';
path2hand = 'CerealBox.stl';

objectScaleFactor = 5;
handScaleFactor = 15;

stepsToSearch = 3;
collisionThreshold = 0.1;

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
    tic;
    vox = getVoxelisedVerts(objectV,objectF,5);
    obj2draw = translateMesh(objectV,[tran(transform,2),tran(transform,3),tran(transform,4)]);
    obj2draw = obj2draw * (quatrotate(tran(transform,5:8),eye(3)).');
    vox = translateMesh(vox,[tran(transform,2),tran(transform,3),tran(transform,4)]);
    vox = vox * (quatrotate(tran(transform,5:8),eye(3)).');
    %obj2draw = rotateMesh(obj2draw,[tran(transform,5),tran(transform,6),tran(transform,7)],tran(transform,8));
    %patch(obj2draw(:,1),obj2draw(:,2),obj2draw(:,3),'red');
    %patch('Faces',objectF,'Vertices',obj2draw,'FaceColor','none','EdgeColor','green','LineWidth',1);
    stlPlot(obj2draw,objectF,true);
    scatter3(vox(:,1),vox(:,2),vox(:,3), '.r');
    toc;
end
stlPlot(handV,handF,true,'Object & Hand');
camlight('headlight');
material('dull');

