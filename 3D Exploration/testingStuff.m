% [v,f] = stlRead('roboHand.stl');
% v(:,4) = 1;
% tform = makehgtform('translate',5,8,19,'axisrotate',[2,5,1],pi/3);
% v = (tform * v.').';
% v = v(:,1:3);
% stlPlot(v,f);
% camlight('headlight');
% material('dull');
% figure;
% v(:,4) = 1;
% v = (inv(tform) * v.').';
% v = v(:,1:3);
% stlPlot(v,f);
% camlight('headlight');
% material('dull');

path = 'obj1_sub7_grasp1_extreme0_object_transform.txt';
text = fileread(path);
text = regexprep(text,'[',' ');
text = regexprep(text,']',' ');
s = strsplit(text);
s = str2double(s);
matrixA = reshape(s(2:17), [4,4]).';
matrixB = reshape(s(19:34), [4,4]).';


