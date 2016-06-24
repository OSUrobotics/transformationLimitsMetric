[v,f,no,na] = stlRead('PitcherAssm.stl');
fv.vertices = v;
fv.faces = f;

xRange = range(fv.vertices(:,1));
yRange = range(fv.vertices(:,2));
zRange = range(fv.vertices(:,3));

res = 0.25;
xRes = ceil(xRange * res);
yRes = ceil(yRange * res);
zRes = ceil(zRange * res);

OUT = VOXELISE(xRes,yRes,zRes,fv,'xyz');
clf; 
hold on;
[ryan1,ryan2,ryan3] = ind2sub(size(OUT),find(OUT));
scatter3(ryan1,ryan2,ryan3,'k.');

axis image
grid on
grid minor