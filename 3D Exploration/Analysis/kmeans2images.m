function kmeans2images( kmeansMat, namesMatrix, imageDir, outputDir )
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
    for imageIndex = 1:size(indices,1)
        copyfile(sprintf('%s/%s',imageDir,namesMatrix{imageIndex}),sprintf('%s/Cluster%i',outputDir,clusterIndex));
    end
end
end

