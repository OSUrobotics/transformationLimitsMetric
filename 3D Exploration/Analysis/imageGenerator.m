%A short script that draws and saves all of the grasps from pathMapping.csv
handObjectLinking = table2cell(readtable('pathMapping.csv'));
for i = 1:size(handObjectLinking,1)
    clf;
    [objectV, objectF] = stlRead(handObjectLinking{i,2});
    [handV,handF,objectV,objectSurf] = loadHandObject(handObjectLinking{i,4},-[0 0 0.085/2+0.08],handObjectLinking{i,1},objectV,[0 0 0],0.385,0.5);
    stlPlot(objectV,objectF);
    stlPlot(handV, handF);
    addLight;
    [~,filename,~] = fileparts(handObjectLinking{i,4});
    saveGraphics(sprintf('Images/%s.jpg',filename),[1080,1080]);
end