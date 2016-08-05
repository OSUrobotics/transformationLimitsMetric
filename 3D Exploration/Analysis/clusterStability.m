function clusterStability( index1, index2, matrix, clusters, epsilon )
%% CLUSTERSTABILITY Prints the number of times index1 and index2 are clustered together
%==========================================================================
%
% USAGE
%
%       clusterStability( index1, index2, matrix, clusters )
%
%       clusterStability( index1, index2, matrix, minPts, epsilon )
%
% INPUTS
%
%       index1          - Mandatory - Integer Value     - Matrix containing kmeans results
%
%       index2          - Mandatory - Integer Value     - Array containing grasp names that line up with the kmeansMat
%
%       matrix          - Mandatory - NxM Matrix        - Path to the dir containing the grasp images
%
%       clusterType     - Mandatory - String            - 'kmeans' or 'dbscan' Select the desired method
%
%       clusters        - Optional  - Integer Value     - Number of clusters to use for kmeans clustering
%
%       minPts          - Optional  - Integer Value     - Minimum number of points per cluster for dbscan clustering
%
%       epsilon         - Optional  - Double Value      - Radius argument for dbscan algorithm.
%
% NOTES
%
%   -Easiest way to get index values of particular grasps is to find them in the names output matrix from load4clustering
%
%==========================================================================

clc;
if strcmp(clusterType,'kmeans')
    for j = 1:4
        together = 0;
        apart = 0;
        for i = 1:100
            kOut = kmeans(matrix,clusters);
            if kOut(index1) == kOut(index2)
                together = together + 1;
            else
                apart = apart + 1;
            end
        end
        fprintf('Together(%i): %i\nApart(%i): %i\n\n',j,together,j,apart);
    end
elseif strcmp(clusterType,'dbscan')
    for j = 1:4
        together = 0;
        apart = 0;
        for i = 1:100
            kOut = dbscan(matrix,epsilon,cluster); %If this is run, assume that clusters is actually min points
            if kOut(index1) == kOut(index2)
                together = together + 1;
            else
                apart = apart + 1;
            end
        end
        fprintf('Together(%i): %i\nApart(%i): %i\n\n',j,together,j,apart);
    end
else
    error('Unrecognized cluster type')
end
end


