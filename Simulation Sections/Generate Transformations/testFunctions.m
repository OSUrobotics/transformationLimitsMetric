values = [1 2 3 1 55 23 pi/3];
[x,y,z] = sphere(20);
pts = [x(:) y(:) z(:)];
stepNums = 20;
translateScalar = 10;
[ ptsOutEXPM, positionTransformsEXPM ] = eulerIntegration3dFromValuesEXPM( values, pts, stepNums, translateScalar);
[ ptsOut, positionTransformsVector, positionTransformsMatrix] = eulerIntegration3dFromValues( values, pts, stepNums, translateScalar);
clf, close all;
visualizeTransformations(ptsOutEXPM)
title('EXPM');
axis image;
figure
visualizeTransformations(ptsOut)
title('MATRIX');
axis image;
