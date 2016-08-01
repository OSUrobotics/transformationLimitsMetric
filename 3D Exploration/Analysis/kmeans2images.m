function kmeans2images( kmeansMat, namesMatrix, imageDir, outputDir, imageFiletype )
%% KMEANS2IMAGES Creates a folder with images sorted based on clusters
%==========================================================================
%
% USAGE
%
%       kmeans2images( kmeansMat, namesMatrix, imageDir, outputDir, imageFiletype )
%
% INPUTS
%
%       kmeansMat       - Mandatory - Kmeans Output Matrix      - Matrix containing kmeans results
%
%       namesMatrix     - Mandatory - Cell Array                - Array containing grasp names that line up with the kmeansMat
%
%       imageDir        - Mandatory - Filepath String           - Path to the dir containing the grasp images
%
%       outputDir       - Mandatory - Filepath String           - Path to the dir you want the sorted files to end up in
%
%       imageFiletype   - Mandatory - File extension String     - Image filetype (ex: .bmp)
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
%Get unique values in kmeansMat, and count them
numberOfClusters = size(unique(kmeansMat),1);
for clusterIndex = 1:numberOfClusters
    indices = find(kmeansMat == clusterIndex);
    mkdir(outputDir,sprintf('Cluster%i',clusterIndex));
    fprintf('Cluster %i \n', clusterIndex);
    for imageIndex = 1:size(indices,1)
        [~,name,~] = fileparts(namesMatrix{indices(imageIndex)});
        name = name(1:end-16);
        copyfile(sprintf('%s/%s%s',imageDir,name,imageFiletype),sprintf('%s/Cluster%i',outputDir,clusterIndex));
        fprintf('Grasp: %s \n',namesMatrix{indices(imageIndex)});
%         if clusterIndex == 99
%             winopen(sprintf('handAndAlignment/hand/%s.stl',namesMatrix{indices(imageIndex)}(1:end-20)));
%         end
    end
end
end

