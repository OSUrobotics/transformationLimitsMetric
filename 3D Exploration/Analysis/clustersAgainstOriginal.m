function [dataOut, percentOut] = clustersAgainstOriginal(clusterOut, names)
% originalClusters = dir('data_for_matt_and_ryan');
% 
% originalClusters = originalClusters(6:end);
% 
% truePos = 0;
% falseNeg = 0;
% 
% for i = 1:size(originalClusters,1)
%     For each original Cluster
%     grasps = dir(sprintf('data_for_matt_and_ryan/%s/*.stl',originalClusters(i).name));
%     if size(grasps,1) < 2
%         name = strfind(names,grasps(1).name(1:end-4));
%         name = find(~cellfun(@isempty,name));
%         oClustersI(name)=i;
%         continue;
%     end
%     for j = 1:size(grasps,1)-1
%         for k = j+1:size(grasps,1)
%             For each combination of grasps in the original cluster
%             name1I = strfind(names,grasps(j).name(1:end-4));
%             name2I = strfind(names,grasps(k).name(1:end-4));
%             name1I = find(~cellfun(@isempty,name1I));
%             name2I = find(~cellfun(@isempty,name2I));
%             
%             oClustersI(name1I) = i;
%             oClustersI(name2I) = i;
%             
%             if clusterOut(name1I) == clusterOut(name2I) & clusterOut(name1I) ~= 0
%                 truePos = truePos + 1;
%             else
%                 falseNeg = falseNeg + 1;
%             end
%         end
%     end
% end
% 
% generatedClusters = dir('ClusterOut');
% 
% generatedClusters = generatedClusters(4:end);
% 
% falsePos = 0;
% trueNeg = 0;
% num = 0;
% for i = 1:size(generatedClusters,1)
%     For each original Cluster
%     grasps = dir(sprintf('ClusterOut/%s/*.jpg',generatedClusters(i).name));
%     if size(grasps,1) < 2
%         continue;
%     end
%     for j = 1:size(grasps,1)-1
%         for k = j+1:size(grasps,1)
%             For each combination of grasps in the original cluster
%             name1I = strfind(names,grasps(j).name(1:end-4));
%             name2I = strfind(names,grasps(k).name(1:end-4));
%             name1I = find(~cellfun(@isempty,name1I));
%             name2I = find(~cellfun(@isempty,name2I));
%             
%             if oClustersI(name1I) == oClustersI(name2I) & oClustersI(name1I) ~= 0
%                 num = num+1;
%                 disp(num)
%             else
%                 falsePos = falsePos + 1;
%             end
%         end
%     end
% end
% 
% out = [truePos, trueNeg, falsePos, falseNeg];

originalClusters = dir('data_for_matt_and_ryan');

originalClusters = originalClusters(6:end);

for i = 1:size(originalClusters,1)
    %For each original Cluster
    grasps = dir(sprintf('data_for_matt_and_ryan/%s/*.stl',originalClusters(i).name));
    if size(grasps,1) < 2
        name = strfind(names,grasps(1).name(1:end-4));
        name = find(~cellfun(@isempty,name));
        clustersI(name)=i;
        continue;
    end
    for j = 1:size(grasps,1)-1
        for k = j+1:size(grasps,1)
            %For each combination of grasps in the original cluster
            name1I = strfind(names,grasps(j).name(1:end-4));
            name2I = strfind(names,grasps(k).name(1:end-4));
            name1I = find(~cellfun(@isempty,name1I));
            name2I = find(~cellfun(@isempty,name2I));
            %Set their values in the cluster matrix
            clustersI(name1I) = i;
            clustersI(name2I) = i;
        end
    end
end

clustersI = [clustersI' clusterOut];

dataOut = [0,0,0,0];

for i = 1:size(clustersI,1)-1
    for j = i+1:size(clustersI,1)
        if (clustersI(i,2) == 0 && clustersI(j,2) == 0) && (clustersI(i,1) == clustersI(j,1))
            dataOut(4) = dataOut(4) + 1; %Add to False Negative (Because both were marked as noise, and should have been together)
        elseif (clustersI(i,2) == 0 && clustersI(j,2) == 0) && (clustersI(i,1) ~= clustersI(j,1))
            dataOut(1) = dataOut(1) + 1; %Add to True Positive (Because both were marked as noise, and they weren't grouped together)
        elseif (clustersI(i,2) == 0 || clustersI(j,2) == 0) && (clustersI(i,1) == clustersI(j,1))
            dataOut(4) = dataOut(4) + 1; %Add to False Negative (Because one was marked as noise, and they were supposed to be together)
        elseif (clustersI(i,2) == 0 || clustersI(j,2) == 0) && (clustersI(i,1) ~= clustersI(j,1))
            dataOut(1) = dataOut(1) + 1; %Add to True Positive (Because one was noise, and they wern't grouped together)
            
            
        elseif clustersI(i,1) == clustersI(j,1) && clustersI(i,2) == clustersI(j,2)
            dataOut(1) = dataOut(1) + 1; %Add to True Positive
        elseif clustersI(i,1) ~= clustersI(j,1) && clustersI(i,2) ~= clustersI(j,2)
            dataOut(2) = dataOut(2) + 1; %Add to True Negative
        elseif clustersI(i,1) ~= clustersI(j,1) && clustersI(i,2) == clustersI(j,2)
            dataOut(3) = dataOut(3) + 1; %Add to False Positive
        elseif clustersI(i,1) == clustersI(j,1) && clustersI(i,2) ~= clustersI(j,2)
            dataOut(4) = dataOut(4) + 1; %Add to False Negative
        end
    end
end

percentOut = (dataOut ./ sum(dataOut)).*100;

end
