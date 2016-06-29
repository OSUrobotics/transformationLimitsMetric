%% For testing transformations
[x,y,z] = sphere(16);
pointsUp = [x(:) y(:) z(:) ones(289,1)];
pointsUp = eye(4);
translate = makehgtform('translate',[0 0 11])
rotate = makehgtform('axisrotate',[1 0 0],pi/4)
TR = translate * rotate
RT = rotate * translate
figure
subplot(3,3,1)
plot3(pointsUp(:,1),pointsUp(:,2),pointsUp(:,3))
title('original')
axis image
subplot(3,3,2)
plot3(pointsUp(:,1),pointsUp(:,2),pointsUp(:,3))
translated = pointsUp*(translate')
hold on
plot3(translated(:,1),translated(:,2),translated(:,3))
axis image
title('translated')
subplot(3,3,3)
plot3(pointsUp(:,1),pointsUp(:,2),pointsUp(:,3))
rotated = pointsUp*(rotate')
hold on
plot3(rotated(:,1),rotated(:,2),rotated(:,3))
axis image
title('rotated')
subplot(3,3,4)
plot3(pointsUp(:,1),pointsUp(:,2),pointsUp(:,3))
TRd = pointsUp*(TR')
hold on
plot3(TRd(:,1),TRd(:,2),TRd(:,3))
axis image
title('rotated then translated')
subplot(3,3,5)
plot3(pointsUp(:,1),pointsUp(:,2),pointsUp(:,3))
RTd = pointsUp*(RT')
hold on
plot3(RTd(:,1),RTd(:,2),RTd(:,3))
axis image
title('translated then rotated')
