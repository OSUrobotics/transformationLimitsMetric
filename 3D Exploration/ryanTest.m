clf
[v,f] = read_ply('PitcherAssmM.ply');

voxels = getVoxelisedVerts(v,f, 0.5);

hold off;
scatter3(voxels(:,1),voxels(:,2),voxels(:,3),'k.');
hold on;

[v2,f2] = stlRead('CrackerBox.stl');

v2 = translateMesh(v2,[0,0,1],100);

stlPlot(v2,f2,na);
figure;

voxels2 = [voxels; v];
points = [voxels2(:,1), voxels2(:,2), voxels2(:,3), intriangulation(v2,f2,voxels2)];

condition = points(:,4)==0;

points(condition, :) = [];

scatter3(points(:,1), points(:,2), points(:,3), '.r');

[vol, surf] = meshVolume(v,f);

percent = getPercentCollisionFVwESaW(v,voxels,v2,f2,0.5,8,1);
disp (percent)

axis image
grid on
grid minor