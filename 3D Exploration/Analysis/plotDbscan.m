originalClusters = dir('data_for_matt_and_ryan');

originalClusters = originalClusters(6:end);

distances = [];
for i = 1:size(originalClusters,1)
    %For each original Cluster
    grasps = dir(sprintf('data_for_matt_and_ryan/%s/*.stl',originalClusters(i).name));
    if size(grasps,1) < 2
        continue;
    end
%     for j = 1:size(grasps,1)-1
    j = 1;
        for k = j+1:size(grasps,1)
            %For each combination of grasps in the original cluster
            %[~,name1] = fileparts(sprintf('data_for_matt_and_ryan/%s/%s',originalClusters(i).name, grasps(j).name));
            %[~,name2] = fileparts(sprintf('data_for_matt_and_ryan/%s/%s',originalClusters(i).name, grasps(k).name));
            name1I = strfind(names(1:end-20),grasps(j).name(1:end-4));
            name2I = strfind(names(1:end-20),grasps(k).name(1:end-4));
            name1I = find(~cellfun(@isempty,name1I));
            name2I = find(~cellfun(@isempty,name2I));
            try
                distances(i,k-1) = pdist2(clusterIn(name1I,:),clusterIn(name2I,:));
            catch
                warning('Empty matrix');
            end
        end
%     end
end

clf;
hold on;
distances = sort(distances,2);
distances(distances == 0) = NaN;
plot(distances.','.b-');

distances = [];
for i = 1:size(originalClusters,1)
    %For each original Cluster
    grasps = dir(sprintf('data_for_matt_and_ryan/%s/*.stl',originalClusters(i).name));
    grasps2 = dir(sprintf('data_for_matt_and_ryan/%s/*.stl',originalClusters(59).name));
    if size(grasps,1) < 2
        continue;
    end
%     for j = 1:size(grasps,1)-1
    j = 1;
        for k = j+1:size(grasps,1)
            %For each combination of grasps in the original cluster
            %[~,name1] = fileparts(sprintf('data_for_matt_and_ryan/%s/%s',originalClusters(i).name, grasps(j).name));
            %[~,name2] = fileparts(sprintf('data_for_matt_and_ryan/%s/%s',originalClusters(i).name, grasps(k).name));
            name1I = strfind(names(1:end-20),grasps(j).name(1:end-4));
            name2I = strfind(names(1:end-20),grasps2(1).name(1:end-4));
            name1I = find(~cellfun(@isempty,name1I));
            name2I = find(~cellfun(@isempty,name2I));
            try
                distances(i,k-1) = pdist2(clusterIn(name1I,:),clusterIn(name2I,:));
            catch
                warning('Empty matrix');
            end
        end
%     end
end

hold on;
distances = sort(distances,2);
distances(distances == 0) = NaN;
plot(distances.','.r-');


