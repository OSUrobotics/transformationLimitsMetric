function clusters2images( clustersMat, namesMatrix, imageDir, outputDir, imageFiletype, moveData, dataDir )
%% CLUSTERS2IMAGES Creates a folder with images sorted based on clusters
%==========================================================================
%
% USAGE
%
%       clusters2images( kmeansMat, namesMatrix, imageDir, outputDir, imageFiletype )
%
% INPUTS
%
%       clustersMat     - Mandatory - Cluster Output Matrix     - Matrix containing cluster results in the form of cluster numbers
%
%       namesMatrix     - Mandatory - Cell Array                - Array containing grasp names that line up with the kmeansMat
%
%       imageDir        - Mandatory - Filepath String           - Path to the dir containing the grasp images
%
%       outputDir       - Mandatory - Filepath String           - Path to the dir you want the sorted files to end up in
%
%       imageFiletype   - Mandatory - File extension String     - Image filetype (ex: .bmp)
%
%       moveData        - Mandatory - Logical Value             - If true grasp data will be moved to separate cluster folders
%
%       dataDir         - Optional  - Filepath String           - Path to the dir containg the grasp data to be moved.
%
% NOTES
%
%   -Names of images must match the names of the grasps (except for the file extension)
%
%==========================================================================

%check for image directory
if exist(imageDir,'dir') ~= 7
    error('Image directory does not exist');
end
%Check for output directory
if exist(outputDir,'dir')
    warning('Output directory already exists, do you want to overwrite it?');
    in = input('[Y/N]: ','s');
    %If it already exists, ask to overwrite
    if(in ~= 'Y')
        %If no overwrite, abort
        disp('Aborting operation...');
        return;
    else
        %Else, overwrite folder
        disp('Overwriting output directory...');
        rmdir(outputDir,'s');
        mkdir(outputDir);
    end
end
%Get unique values in clustersMat, and count them
numberOfClusters = size(unique(clustersMat),1);
for clusterIndex = 0:numberOfClusters-1
    indices = find(clustersMat == clusterIndex);
    mkdir(outputDir,sprintf('Cluster%i',clusterIndex));
    if moveData == true
        mkdir(outputDir,sprintf('zzDataCluster%i',clusterIndex));
    end
    fprintf('Cluster %i \n', clusterIndex);
    for imageIndex = 1:size(indices,1)
        [~,name,~] = fileparts(namesMatrix{indices(imageIndex)});
        name = name(1:end-16);
        copyfile(sprintf('%s/%s%s',imageDir,name,imageFiletype),sprintf('%s/Cluster%i',outputDir,clusterIndex));
        if moveData == true
            for i = 1:9
                copyfile(sprintf('%s/Step%i%s%s',dataDir,i,name,'AreaIntersection.csv'),sprintf('%s/zzDataCluster%i',outputDir,clusterIndex));
            end
        end
        fprintf('Grasp: %s \n',namesMatrix{indices(imageIndex)});
%         if clusterIndex == 99
%             winopen(sprintf('handAndAlignment/hand/%s.stl',namesMatrix{indices(imageIndex)}(1:end-20)));
%         end
    end
end
end

