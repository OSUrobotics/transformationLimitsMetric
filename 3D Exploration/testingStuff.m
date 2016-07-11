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

% path = 'obj1_sub7_grasp1_extreme0_object_transform.txt';
% text = fileread(path);
% text = regexprep(text,'[',' ');
% text = regexprep(text,']',' ');
% s = strsplit(text);
% s = str2double(s);
% matrixA = reshape(s(2:17), [4,4]).';
% matrixB = reshape(s(19:34), [4,4]).';

[v,f] = read_ply('PitcherAssmMTest.ply');
[v2,f2] = read_ply('PitcherAssmMTest.ply');
v2 = v2 / 1000;
stlPlot(v,f);
v(:,4) = 1;
v = v * makehgtform('translate',50,0,0).';
v = v(:,1:3);
stlPlot(v,f);
camlight('headlight');
material('dull');
figure;
stlPlot(v2,f2);
v2(:,4) = 1;
v2 = v2 * makehgtform('translate',50/1000,0,0).';
v2 = v2(:,1:3);
stlPlot(v2,f2);
camlight('headlight');
material('dull');

%Comment, I am a comment.  Yes, indeed...