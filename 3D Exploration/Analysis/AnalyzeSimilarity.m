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

% Get mapping
%similarity = table2cell(readtable('../../GraspStudies/Compare.csv'));
similarity = table2cell(readtable('../../GraspStudies/SimilaritySaurabh.csv'));


%% Loop through the comparisons and plot
nDirs = transformationStruct.numTranslationDirections * ...
    transformationStruct.numRotationAxes * ...
    length(transformationStruct.angleDivisions);
nComparisons = size( similarity, 1 );
nVals = nDirs * (transformationStruct.numInterpolationSteps - 1);
data = zeros( nDirs, transformationStruct.numInterpolationSteps - 1 );
dataDiffs = zeros( nDirs, transformationStruct.numInterpolationSteps - 1 );

clf
nRows = 1;
nCols = 2;
for r = 1:nComparisons
    fname = strcat('Output/Wiggle1Step0', similarity{r,1} );
    dataC1 = table2array(readtable(fname));
    dataC1 = dataC1(:,8:end);
    fname = strcat('Output/Wiggle1Step0', similarity{r,2} );
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

    subplot(nRows, nCols, 1);
    if similarity{r,3} < 0.3
        plot( similarity{r,3}, diffsL2, 'Xr');
    elseif similarity{r,3} < 0.7
        plot( similarity{r,3}, diffsL2, 'Ob');
    else
        plot( similarity{r,3}, diffsL2, '*g');
    end
    hold on;

    subplot(nRows, nCols, 2);
    if similarity{r,3} < 0.3
        plot( similarity{r,3}, diffsL2Diff, 'Xr');
    elseif similarity{r,3} < 0.7
        plot( similarity{r,3}, diffsL2Diff, 'Ob');
    else
        plot( similarity{r,3}, diffsL2Diff, '*g');
    end
    hold on;
end
subplot(nRows, nCols, 1);
xlabel('Similarity survey score');
ylabel('L^2 difference');
title('Score on similarity');

subplot(nRows, nCols, 2);
xlabel('Similarity survey score');
ylabel('L^2 difference of difference');
title('Score on similarity');


fname = 'Images/SimilarityGraph.pdf';
saveGraphics(fname,[1080,2080]);

