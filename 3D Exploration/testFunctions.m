%% Load the files and prepare for graphing
path2object ='PitcherAssm.stl';
objectScaleFactor = 10;
%% Load the object and scale to origin
[objectV,objectF] = stlRead(path2object); % Gives vertical vertices matrix,association matrix
objectVpad = [objectV ones(size(objectV,1),1)]; % Pad the points list with ones to work with 4x4 transformation matrices
objectVpad = objectVpad*(makehgtform('translate',-getCentroidMesh(objectV)).'); % Translate the object to origin
objectVpad = objectVpad*(makehgtform('scale',objectScaleFactor/max(abs(objectV(:)))).'); % Scale the object to one,then to the scaleFactor inputted
objectV = objectVpad(:,1:3); % Remove padding
%objectVox = getVoxelisedVerts(objectV,objectF,voxelResolution);
%% General interesting information about file
fprintf('Number of vertices: %i\n',size(objectV,1));
fprintf('Centroid of Mesh: (%0.5f, %0.5f, %0.5f)\n',getCentroidMesh(objectV));

%% Make transformation values
transformationValues = makeTransformationValuesOld(2,2,50);
transformationValues = transformationValues(1:10,:);
%% Make example object
[x,y,z] = sphere(20);
sphereVertices = [x(:) y(:) z(:)];
stepNums = 10;
%% Loop through and render on the plot
clf;
for values = transformationValues.'
    [ ptsOut, ~, ~ ] = eulerIntegration3dFromValues(values, objectV, stepNums, 35);
    visualizeTransformations(ptsOut);
    hold on
end
axis image
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
figure
%% stlPlot demo
stlPlot(objectV,objectF,true)
camlight('headlight');
material('dull');