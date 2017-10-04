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

% Load in the comparisons
strSaveComparisons = 'Output/comparison.mat';
if exist( strSaveComparisons, 'file' )
    load( strSaveComparisons );
else
    GraspGroupings;
end

% Get mapping
%similarity = table2cell(readtable('../../GraspStudies/Compare.csv'));
similarity = table2cell(readtable('../../GraspStudies/SimilaritySaurabh.csv'));


%% Loop through the comparisons and plot
nDirs = transformationStruct.numTranslationDirections * ...
    transformationStruct.numRotationAxes * ...
    length(transformationStruct.angleDivisions);
nComparisons = size( similarity, 1 );
nVals = nDirs * (transformationStruct.numInterpolationSteps - 1);


dataToPlotL2 = zeros( 2, nComparisons );
dataToPlotL2Diff = zeros( 2, nComparisons );
for r = 1:nComparisons
    fname = strcat('Output/Step0', similarity{r,1} );
    dataC1 = table2array(readtable(fname));
    dataC1 = dataC1(:,8:end);
    fname = strcat('Output/Step0', similarity{r,2} );
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
    
    dataToPlotL2( 1, r ) = similarity{r,3};
    dataToPlotL2( 2, r ) = diffsL2;
    
    dataToPlotL2Diff( 1, r ) = similarity{r,3};
    dataToPlotL2Diff( 2, r ) = diffsL2Diff;
    
    if mod(r,10) == 0
        fprintf('.');
    end
end
figure(2)
clf
nRows = 2;
nCols = 2;

fprintf('\n');
subplot(nRows, nCols, 1);
indx = dataToPlotL2(1,:) < 0.3;
plot( dataToPlotL2(1, indx), dataToPlotL2(2, indx), 'Xr' );
hold on;
indx = dataToPlotL2(1,:) >= 0.3 & dataToPlotL2(1,:) < 0.7;
plot( dataToPlotL2(1, indx), dataToPlotL2(2, indx), 'Ob' );
indx = dataToPlotL2(1,:) >= 0.7;
plot( dataToPlotL2(1, indx), dataToPlotL2(2, indx), '*g' );
xlabel('Similarity survey score');
ylabel('L^2 difference');
title('Score on similarity');

subplot(nRows, nCols, 3);
indx = dataToPlotL2(1,:) < 0.3;
dataToPlotL2(1,indx) = 0;
indx = dataToPlotL2(1,:) >= 0.3 & dataToPlotL2(1,:) < 0.7;
dataToPlotL2(1,indx) = 0.5;
indx = dataToPlotL2(1,:) >= 0.7;
dataToPlotL2(1,indx) = 1;
boxplot( squeeze(dataToPlotL2(2,:)), squeeze(dataToPlotL2(1,:)) );
xlabel('Similarity survey score');
ylabel('L^2 difference');
set(gca,'XTickLabel',{'Similar', 'Shape same'})
rotateXLabels( gca(), 45 );
title('Score on similarity');

%%%%% Diffs

subplot(nRows, nCols, 2);
indx = dataToPlotL2(1,:) < 0.3;
plot( dataToPlotL2(1, indx), dataToPlotL2Diff(2, indx), 'Xr' );
hold on;
indx = dataToPlotL2(1,:) >= 0.3 & dataToPlotL2(1,:) < 0.7;
plot( dataToPlotL2(1, indx), dataToPlotL2Diff(2, indx), 'Ob' );
indx = dataToPlotL2(1,:) >= 0.7;
plot( dataToPlotL2(1, indx), dataToPlotL2Diff(2, indx), '*g' );

subplot(nRows, nCols, 4);
boxplot( squeeze(dataToPlotL2Diff(2,:)), squeeze(dataToPlotL2(1,:)) );

xlabel('Similarity survey score');
ylabel('L^2 difference of diff');
set(gca,'XTickLabel',{'Similar', 'Shape same'})
rotateXLabels( gca(), 45 );
title('Score on similarity');



fname = 'Images/SimilarityGraph.pdf';
saveGraphics(fname,[1080,2080]);

