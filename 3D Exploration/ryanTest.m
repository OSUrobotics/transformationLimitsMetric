clf
[v,f,no,na] = stlRead('sphere_ascii.stl');

voxels = getVoxelisedVerts(v,f, 0.25);

hold off;
scatter3(voxels(:,1),voxels(:,2),voxels(:,3),'k.');
hold on;

[v,f,no,na] = stlRead('PringlesCan.stl');
%v = translateMesh(v,[1,1,1],15);

stlPlot(v,f,na);
figure;

points = [voxels(:,1), voxels(:,2), voxels(:,3), intriangulation(v,f,voxels)]

condition = points(:,4)==0;

points(condition, :) = [];

scatter3(points(:,1), points(:,2), points(:,3), '.r');

axis image
grid on
grid minor