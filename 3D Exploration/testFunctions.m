%% Load the files and prepare for graphing
stlPath = 'stlTools/femur_binary.stl'; % sample object
load('../transformationValues.mat');
figure
[vertices,faces,~,~] = stlReadBinary(stlPath); % read stl in as faces and vertex
%% General interesting information about file
fprintf('Number of vertices: %i\n',size(vertices,1));
fprintf('Centroid of Mesh: (%0.5f, %0.5f, %0.5f)\n',getCentroidMesh(vertices));

%% Make transformation values
% transformationValues = makeTransformationValues(2,2,5);
transformationValues = valuesIn;
transformationValues = transformationValues(1:30,:);
%% Make example object
[x,y,z] = sphere(20);
sphereVertices = [x(:) y(:) z(:)];
stepNums = 10;
%% Loop through and render on the plot
clf;
for values = transformationValues.'
    [ ptsOut, positionTransformsVector, positionTransformsMatrix ] = eulerIntegration3dFromValues(values, sphereVertices, stepNums, 10);
    visualizeTransformations(vertices,faces);
end
axis image
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');