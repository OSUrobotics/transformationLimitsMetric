%% Load the files and prepare for graphing
stlPath = 'stlTools/femur_binary.stl'; % sample object
close all;
figure
[vertices,faces,~,~] = stlRead(stlPath); % read stl in as faces and vertex
%% General interesting information about file
fprintf('Number of vertices: %i\n',size(vertices,1));
fprintf('Centroid of Mesh: (%0.5f, %0.5f, %0.5f)\n',getCentroidMesh(vertices));
%% Plot before transformation plot
ax1 = subplot(1,2,1);
stlPlot(vertices,faces,'Original');
%% Generate and plot the transformed object
transformedVertices = translateMesh(vertices,[1,1,2],5); % apply the transformation
ax2 = subplot(1,2,2);
stlPlot(transformedVertices,faces,'Transformed');
%% Link the graph movement
Link = linkprop([ax1, ax2], {'CameraUpVector', 'CameraPosition', 'CameraTarget'});
setappdata(gcf, 'StoreTheLink', Link);

%% Test sphere generation
sphereish = IcosahedronMesh;
sphereish = SubdivideSphericalMesh(sphereish,2);
figure
title('directional sphere')
patch(sphereish,'FaceColor',   [0.8 0.8 1.0], ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15)
axis image;

%% Test object transformation
figure
subplot(1,2,1);
stlPlot(vertices,faces,'Original');
ax2 = subplot(1,2,2);
for index = 1:size(sphereish.vertices,1)
    disp(index);
    transformedVertices = translateMesh(vertices,sphereish.vertices(index,:),3);
    stlPlot(transformedVertices,faces,'',false);
    hold on
end