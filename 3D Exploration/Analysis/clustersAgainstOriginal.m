function [dataOut, percentOut] = clustersAgainstOriginal(clusterOut, names)
%% LOAD4CLUSTERING Takes in a directory name and returns a list of values for the data in that folder
%==========================================================================
%
% USAGE
%       [ dataOut, percentOut ] = clustersAgainstOriginal( clusterOut, names )
%
% INPUTS
%
%       clusterOut  - Mandatory - Matrix        - Results from clustering
%
%       names       - Mandatory - Cell Array    - Names from prepping for clustering
%
% OUTPUTS
%
%       dataOut     - Mandatory - 1x4 Vector    - Vector containing [Tp,Tn,Fp,Fn]
%       
%       percentOut  - Optional  - NxM Matrix    - Vector containing dataOut in percentage form
%
%==========================================================================

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
            dataOut(2) = dataOut(2) + 1; %Add to True Negative (Because both were marked as noise, and they weren't grouped together)
        elseif (clustersI(i,2) == 0 || clustersI(j,2) == 0) && (clustersI(i,1) == clustersI(j,1))
            dataOut(4) = dataOut(4) + 1; %Add to False Negative (Because one was marked as noise, and they were supposed to be together)
        elseif (clustersI(i,2) == 0 || clustersI(j,2) == 0) && (clustersI(i,1) ~= clustersI(j,1))
            dataOut(2) = dataOut(2) + 1; %Add to True Negative (Because one was noise, and they wern't grouped together)
            
            
        elseif clustersI(i,1) == clustersI(j,1) && clustersI(i,2) == clustersI(j,2)
            dataOut(1) = dataOut(1) + 1; %Add to True Positive
        elseif clustersI(i,1) ~= clustersI(j,1) && clustersI(i,2) ~= clustersI(j,2)
            dataOut(2) = dataOut(2) + 1; %Add to True Negative
        elseif clustersI(i,1) ~= clustersI(j,1) && clustersI(i,2) == clustersI(j,2)
            dataOut(3) = dataOut(3) + 1; %Add to False Positive
        elseif clustersI(i,1) == clustersI(j,1) && clustersI(i,2) ~= clustersI(j,2)
            dataOut(4) = dataOut(4) + 1; %Add to False Negative
        else
            error('How the hell did it get here?')
        end
    end
end

percentOut = (dataOut ./ sum(dataOut)).*100;

end
