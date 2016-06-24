clf
[v,f,no,na] = stlRead('sphere_ascii.stl');

voxels = getVoxelisedVerts(v,f, 1);

hold off;
scatter3(voxels(:,1),voxels(:,2),voxels(:,3),'k.');
hold on;

[v2,f2,no,na] = stlRead('PringlesCan.stl');

stlPlot(v2,f2,na);
figure;

points = [voxels(:,1), voxels(:,2), voxels(:,3), intriangulation(v2,f2,voxels)];

condition = points(:,4)==0;

points(condition, :) = [];

scatter3(points(:,1), points(:,2), points(:,3), '.r');

percent = getPercentCollision(v,f,v2,f2);
%percent = int2str(percent);
disp (percent)

axis image
grid on
grid minor