[v,f,no,na] = stlRead('PitcherAssm.stl');
fv.vertices = v;
fv.faces = f;

xRange = range(fv.vertices(:,1));
yRange = range(fv.vertices(:,2));
zRange = range(fv.vertices(:,3));

res = 0.5;
xRes = ceil(xRange * res);
yRes = ceil(yRange * res);
zRes = ceil(zRange * res);

OUT = VOXELISE(xRes,yRes,zRes,fv,'xyz');
clf; 
hold on;

[xIndeces,yIndeces,zIndeces] = ind2sub(size(OUT),find(OUT));
scatter3(xIndeces,yIndeces,zIndeces,'k.');

axis image
grid on
grid minor