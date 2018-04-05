%% This script analyzes the metric values wrt to the similarity scores from the user study
disp('Started script');
%% Declaring transformation settings variables
transformationsFilename = 'transformationStored';
transformationSettings = struct;
transformationSettings.handAndObjectScalar = 1;
transformationSettings.translateScalar = 1;
transformationSettings.numTranslationDirections = 12;
transformationSettings.numRotationAxes = 7;
transformationSettings.angleDivisions = [-1 -.5 -.25 0 .25 .5 1];
transformationSettings.numInterpolationSteps = 10;
handObjectLinkingFilePath = 'pathMapping.csv';
%% If not already loaded, load the transformation values
if ~exist('transformationStruct','var')
    %% If not already created, create the file
    if ~exist(transformationsFilename,'file')
        disp('Started generating transformations');
        transformationStruct = saveTrajectories(transformationSettings,transformationsFilename);
        disp('Done generating transformations');
    else
        load(transformationsFilename);
        disp('Loaded transformations');
    end
else
    disp('Using preloaded transformations');
end
%% Load in file relations between hand settings, object, and transformations, create if not created
if exist(handObjectLinkingFilePath,'file')
    handObjectLinking = table2cell(readtable(handObjectLinkingFilePath));
else
    handObjectLinking = linkFilenames(handObjectLinkingFilePath, 15, true); %Set to 15 for Saurabh's file format
end
disp('Loaded the hand-object-transformation linking csv');


%% Loop through the comparisons and plot
nDirs = transformationStruct.numTranslationDirections * ...
    transformationStruct.numRotationAxes * ...
    length(transformationStruct.angleDivisions);
nComparisons = size( similarity, 1 );
nVals = nDirs * (transformationStruct.numInterpolationSteps - 1);

strSaveComparisons = 'Output/comparison.mat';
if exist( strSaveComparisons, 'file' )
    load( strSaveComparisons );
else
    nGrasps = size( handObjectLinking, 1 );
    comparison = struct;
    comparison.L2 = zeros( nGrasps );
    comparison.L2Diff = zeros( nGrasps );
    comparison.Object = zeros( nGrasps, 1 );
    comparison.Subject = zeros( nGrasps, 1 );
    comparison.Grasp = zeros( nGrasps, 1 );
    comparison.TypeGrasp = cell( nGrasps, 1 );
    for r = 1:nGrasps
        comparison.Object(r) = handObjectLinking{r,5};
        comparison.Subject(r) = handObjectLinking{r,6};
        comparison.Grasp(r) = handObjectLinking{r,7};
        comparison.TypeGrasp{r} = handObjectLinking{r,8};
        
        fname = handObjectLinking{r,9};
        dataC1 = table2array(readtable(fname));
        dataC1 = dataC1(:,8:end);
        for c = r+1:nGrasps
            fname = handObjectLinking{c,9};
            dataC2 = table2array(readtable(fname));
            dataC2 = dataC2(:,8:end);
            
            dataDiffsC1 = dataC1;
            dataDiffsC2 = dataC2;
            for k = 1:nDirs
                seq = [0, dataC1( k, 1:end-1 ) ];
                dataDiffsC1(k, :) = squeeze( dataC1( k, : ) ) - seq;
                
                seq = [0, dataC2( k, 1:end-1 ) ];
                dataDiffsC2(k, :) = squeeze( dataC2( k, : ) ) - seq;
            end
            diffsL2 = sqrt( sum( sum( ( dataC1(:,:) - dataC2(:,:) ).^2 ) ) ) / nVals;
            diffsL2Diff = sqrt( sum( sum( ( dataDiffsC1(:,:) - dataDiffsC2(:,:) ).^2 ) ) ) / nVals;
            
            comparison.L2(r,c) = diffsL2;
            comparison.L2(c,r) = diffsL2;
            comparison.L2Diff(r,c) = diffsL2Diff;
            comparison.L2Diff(c,r) = diffsL2Diff;
        end
    end
    save( strSaveComparisons, 'comparison' );
end

nGrasps = size( comparison.Grasp, 1 );
data = ones( nGrasps * (nGrasps-1) / 2, 3 );
count = 1;
for r = 1:nGrasps
    for c = r+1:nGrasps
        data(count, 1) = comparison.L2(r,c);
        data(count, 2) = comparison.L2Diff(r,c);
        if comparison.Object(r) == comparison.Object(c) && ...
                comparison.Subject(r) == comparison.Subject(c) && ...
                comparison.Grasp(r) == comparison.Grasp(c)
            data(count, 3) = 0;
        elseif comparison.Object(r) == comparison.Object(c)
            data(count, 3) = 1;
        else
            data(count, 3) = 2;
        end
        count = count+1;
    end
end

figure(1)
clf
nRows = 2;
nCols = 2;

subplot(nRows, nCols, 1);
boxplot( data(:, 1), data(:, 3) );
xlabel('Extremes vs others');
ylabel('L^2');
set(gca,'XTickLabel',{'Extremes', 'Shape same', 'Shape different'})
rotateXLabels( gca(), 45 );

title('L^2 by grasp type');

subplot(nRows, nCols, 2);
boxplot( data(:, 2), data(:, 3) );
xlabel('Extremes vs others');
ylabel('L^2 diff');
set(gca,'XTickLabel',{'Extremes', 'Shape same', 'Shape different'})
rotateXLabels( gca(), 45 );
title('L^2 diff by grasp type');

fname = 'Images/Comparisons.pdf';
saveGraphics(fname,[1080,2080]);

subplot(nRows, nCols, [3 4] );
nPixs = 512;
imOut = uint8( zeros( nPixs, nPixs * 9, 3 ) );
for r = 1:nGrasps
    strType = comparison.TypeGrasp{r};
    if strncmp(strType, 'optimal', 7 )
        strName = sprintf('Images/obj%0.0f_sub%0.0f_grasp%0.0f_%s.jpg', ...
            comparison.Object(r), comparison.Subject(r), comparison.Grasp(r), strType );
        imGrasp = imread( strName );
        imGraspBig = imcrop( imGrasp, [200, 200, 800, 800 ] );
        imGraspScale = imresize( imGraspBig, [nPixs, nPixs] );
        imGraspScale(:,end-4:end,2:3) = 0;
        imOut( :, 1:nPixs, :) = imGraspScale;
        nFound = 1;
        vals = squeeze( comparison.L2(r,:) );
        mid = mean(vals);
        while nFound < 9
            [~,ind] = min( vals );
            vals(ind) = mid;
            bIsOk = false;
            if comparison.Object(r) ~= comparison.Object(ind)
                bIsOk = true;
            elseif comparison.Subject(r) ~= comparison.Subject(ind)
                bIsOk = true;
            elseif comparison.Grasp(r) ~= comparison.Grasp(ind)
                bIsOk = true;
            end
            if ~strncmp(comparison.TypeGrasp{ind}, 'optimal', 7 )
                bIsOk = false;
            end
            if bIsOk == true
                strName = sprintf('Images/obj%0.0f_sub%0.0f_grasp%0.0f_%s.jpg', ...
                    comparison.Object(ind), comparison.Subject(ind), comparison.Grasp(ind), comparison.TypeGrasp{ind} );
                imGrasp = imread( strName );
                imGraspBig = imcrop( imGrasp, [200, 200, 800, 800 ] );
                imGraspScale = imresize( imGraspBig, [nPixs, nPixs] );
                if nFound == 4
                    imGraspScale(:,end-4:end,[1,3]) = 0;
                end
                nStart = nPixs * nFound;
                if nFound > 4
                    nStart = (4+9-nFound) * nPixs;
                end
                imOut( :, nStart:nStart+nPixs-1, :) = imGraspScale;
                imshow(imOut);
                
                nFound = nFound + 1;
                if nFound == 5
                    vals = max(vals) - vals;
                end
            end
        end
        strName = sprintf('Images/Match_obj%0.0f_sub%0.0f_grasp%0.0f_%s.jpg', ...
            comparison.Object(r), comparison.Subject(r), comparison.Grasp(r), strType );
        
        imOut( :, nPixs-2:nPixs+2, 1 ) = 255;
        imshow(imOut);
        imwrite( imOut, strName );
        
    end
end

