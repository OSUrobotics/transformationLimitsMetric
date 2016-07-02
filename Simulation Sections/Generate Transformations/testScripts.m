[x,y,z] = sphere(20);
pts = [x(:) y(:) z(:)];
values = [1 2 5 6 3 2 pi/4];
stepNums = 30000;
translateScalar = 100;
tic;
[ ptsOutEXPM, positionTransformsEXPM ] = eulerIntegration3dFromValuesEXPM( values, pts, stepNums, translateScalar);
toc;
tic;
[ ptsOut, ~,positionTransforms ] = eulerIntegration3dFromValues( values, pts, stepNums, translateScalar);
toc;
%disp(positionTransformsEXPM-positionTransforms);
%clf, close all;
% figure
% visualizeTransformations(ptsOutEXPM);
% title('EXPM');
% axis image;
% view(90,90);
% figure
% visualizeTransformations(ptsOut);
% title('Matrix');
% axis image;
% view(90,90);