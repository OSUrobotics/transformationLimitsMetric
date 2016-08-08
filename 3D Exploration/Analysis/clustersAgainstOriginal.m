originalClusters = dir('data_for_matt_and_ryan');

originalClusters = originalClusters(6:end);

yesMatch = 0;
noMatch = 0;

for i = 1:size(originalClusters,1)
    %For each original Cluster
    grasps = dir(sprintf('data_for_matt_and_ryan/%s/*.stl',originalClusters(i).name));
    if size(grasps,1) < 2
        continue;
    end
    for j = 1:size(grasps,1)-1
        for k = j+1:size(grasps,1)
            %For each combination of grasps in the original cluster
            [~,name1] = fileparts(sprintf('data_for_matt_and_ryan/%s/%s',originalClusters(i).name, grasps(j).name));
            [~,name2] = fileparts(sprintf('data_for_matt_and_ryan/%s/%s',originalClusters(i).name, grasps(k).name));
            name1I = strfind(names(1:end-20),grasps(j).name(1:end-4));
            name2I = strfind(names(1:end-20),grasps(k).name(1:end-4));
            name1I = find(~cellfun(@isempty,name1I));
            name2I = find(~cellfun(@isempty,name2I));
            if clusterOut(name1I) == clusterOut(name2I)
                yesMatch = yesMatch + 1;
            else
                noMatch = noMatch + 1;
                fprintf('___Failure to Match___\nA: %s\nB: %s\n\n',name1,name2)
                
            end
        end
    end
    
end

disp(yesMatch)
disp(noMatch)

