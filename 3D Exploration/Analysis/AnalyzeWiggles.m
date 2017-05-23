%% This script takes the output of runSimFun and compares the wiggles
disp('Started script');
%% Dealing with parpool
% p = gcp('nocreate');
% if isempty(p)
%     parpool(4);
%     p = gcp();
% end
%disp('Parpool started');
%% Declaring transformation settings variables
transformationsFilename = 'transformationStored';
transformationSettings = struct;
transformationSettings.handAndObjectScalar = 1;
transformationSettings.translateScalar = 1;
transformationSettings.numTranslationDirections = 12;
transformationSettings.numRotationAxes = 7;
transformationSettings.angleDivisions = [-1 -.5 -.25 0 .25 .5 1];
transformationSettings.numInterpolationSteps = 10;
handObjectLinkingFilePath = 'pathMappingWiggle.csv';
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

% Get percMoved
load( 'wiggleTest.mat' );


%% Loop through the items in the handObjectLinking list
dirs = {'Small', 'Large'};
fname = sprintf('OutputWiggle%s/wiggleTest.mat', dirs{1});
load( fname );
nObjs = length( percMoved.PairingIndex );
nWiggles = size(percMoved.Wiggles,1);
nDirs = transformationStruct.numTranslationDirections * ...
    transformationStruct.numRotationAxes * ...
    length(transformationStruct.angleDivisions);
data = zeros( 2, nObjs, nWiggles, nDirs, transformationStruct.numInterpolationSteps - 1 );
dataDiffs = zeros( 2, nObjs, nWiggles, nDirs, transformationStruct.numInterpolationSteps - 1 );
nVals = nDirs * (transformationStruct.numInterpolationSteps - 1);
for amnt = 1:2
    fname = sprintf('OutputWiggle%s/wiggleTest.mat', dirs{amnt});
    load( fname );
    
    obj = 1;
    for pairingIndex = percMoved.PairingIndex'
        
        %% Loop through the wiggles and apply
        for wIndex = 1:nWiggles
            %% Load in data
            fname = strcat('OutputWiggle', dirs{amnt}, '/', sprintf( sprintf(handObjectLinking{pairingIndex,10},wIndex,'%i'), 0) );
            dataWiggle = table2array(readtable(fname));
            data(amnt, obj, wIndex,:,:) = dataWiggle(:, 8:end);
            for k = 1:nDirs
                seq = [0, squeeze( data( amnt, obj, wIndex, k, 1:end-1 ) )' ];
                dataDiffs(amnt, obj, wIndex, k, :) = squeeze( data( amnt, obj, wIndex, k, : ) ) - seq';
            end
        end
        
        % Next object
        obj = obj + 1;
    end
end

%% Pairwise comparisons
compareDiffL2 = zeros( 2, nObjs * (nObjs-1)/2, nWiggles, nWiggles );
compareDiffL2Dff = zeros( 2, nObjs * (nObjs-1)/2, nWiggles, nWiggles );
compareWiggleL2 = zeros( 2, nObjs, nWiggles * (nWiggles-1) / 2 );
compareWiggleL2Dff = zeros( 2, nObjs, nWiggles * (nWiggles-1) / 2 );

for amnt = 1:2
    nCountDiff = 1;
    nCountWiggle = 1;
    for k = 1:nObjs
        for l = k:nObjs
            diffsL2 = zeros( nWiggles, nWiggles );
            diffsL2Diff = zeros( nWiggles, nWiggles );
            for w1 = 1:nWiggles
                for w2 = 1:nWiggles
                    diffsL2(w1, w2) = sqrt( sum( sum( squeeze( data(amnt, k,w1,:,:) - data(amnt, l,w2,:,:) ).^2 ) ) ) / nVals;
                    diffsL2Diff(w1, w2) = sqrt( sum( sum( squeeze( dataDiffs(amnt, k,w1,:,:) - dataDiffs(amnt, l,w2,:,:) ).^2 ) ) ) / nVals;
                end
            end
            if k == l
                compareWiggleL2(amnt, nCountWiggle,:) = nonzeros( triu( diffsL2 ) );
                compareWiggleL2Dff(amnt, nCountWiggle,:) = nonzeros( triu( diffsL2Diff ) );
                nCountWiggle = nCountWiggle + 1;
            else
                compareDiffL2(amnt, nCountDiff,:,:) = diffsL2;
                compareDiffL2Dff(amnt, nCountDiff,:,:) = diffsL2Diff;
                nCountDiff = nCountDiff + 1;
            end
        end
    end
end

figure(1)
clf;
nRows = 1;
nCols = 4;
for amnt = 1:2
    compareDiffL2List = reshape( compareDiffL2(amnt,:), [1, numel( compareDiffL2(amnt,:) )] );
    compareDiffL2DffList = reshape( compareDiffL2Dff(amnt,:), [1, numel( compareDiffL2Dff(amnt,:) )] );
    compareWiggleL2List = reshape( compareWiggleL2(amnt,:), [1, numel( compareWiggleL2(amnt,:) )] );
    compareWiggleL2DffList = reshape( compareWiggleL2Dff(amnt,:), [1, numel( compareWiggleL2Dff(amnt,:) )] );
    subplot(nRows,nCols,2*(amnt-1)+1);
    histogram( compareDiffL2List );
    hold on
    histogram( compareWiggleL2List );
    
    subplot(nRows,nCols,2*(amnt-1)+2);
    histogram( compareDiffL2DffList );
    hold on
    histogram( compareWiggleL2DffList );
end

subplot(nRows,nCols,1);
xlabel('L^2 difference');
ylabel('Number');
legend( 'Different', 'Wiggled' );
title(sprintf( 'L^2 metric, %0.0f shapes, small noise', nObjs ) );

subplot(nRows,nCols,3);
xlabel('L^2 difference');
ylabel('Number');
legend( 'Different', 'Wiggled' );
title(sprintf( 'L^2 metric, %0.0f shapes, bigger noise', nObjs ) );

subplot(nRows,nCols,2);
xlabel('L^2 difference of differences');
ylabel('Number');
legend( 'Different', 'Wiggled' );
title(sprintf( 'L^2 difference metric, %0.0f shapes, small noise', nObjs ) );

subplot(nRows,nCols,4);
xlabel('L^2 difference of differences');
ylabel('Number');
legend( 'Different', 'Wiggled' );
title(sprintf( 'L^2 difference metric, %0.0f shapes, bigger noise', nObjs ) );

fname = 'Images/WiggleGraphsI.pdf';
saveGraphics(fname,[580,2080]);

figure(2)
clf;
nRows = 2;
nCols = 4;

names = {'Bottle body', 'Bottle top', 'Glass', 'Box', 'Cylinder', 'Ball'};
labels = cell(1, nObjs * (nObjs-1));
count = 1;
for obj1 = 1:nObjs
    for obj2 = obj1+1:nObjs
        labels(1,count) = strcat(names(obj1), '-', names(obj2) );
        count = count + 1;
    end
end
minDiffL2 = min( min( min( compareDiffL2(1,:,:,:) ) ) );
maxDiffL2 = max( max( max( compareWiggleL2(1,:,:,:) ) ) );

subplot(nRows,nCols,[1 2]);
hold off;
boxplot( squeeze( compareDiffL2(1,:,:) )' );
hold on;
plot( [0, nObjs * (nObjs-1)], [minDiffL2, minDiffL2], '--k' );
plot( [0, nObjs * (nObjs-1)], [maxDiffL2, maxDiffL2], ':k' );
set(gca,'XTickLabel',labels)
rotateXLabels( gca(), 45 );
ylabel('L^2 difference');
title('L^2 norm obj vs obj');

subplot(nRows,nCols,5);
hold off;
boxplot( squeeze( compareWiggleL2(1,:,:) )' );
hold on;
plot( [0, nObjs], [minDiffL2, minDiffL2], '--k' );
plot( [0, nObjs], [maxDiffL2, maxDiffL2], ':k' );
set(gca,'XTickLabel',names)
rotateXLabels( gca(), 45 );
ylabel('L^2 difference');
title('Small');

subplot(nRows,nCols,6);
hold off;
boxplot( squeeze( compareWiggleL2(2,:,:) )' );
hold on;
plot( [0, nObjs], [minDiffL2, minDiffL2], '--k' );
plot( [0, nObjs], [maxDiffL2, maxDiffL2], ':k' );
ylabel('L^2 difference');
set(gca,'XTickLabel',names)
rotateXLabels( gca(), 45 );
title('Bigger');


%minDiffL2 = min( min( min( compareDiffL2Dff(1,:,:,:) ) ) );
%maxDiffL2 = max( max( max( compareWiggleL2Dff(1,:,:,:) ) ) );

subplot(nRows,nCols,[3 4]);
hold off;
boxplot( squeeze( compareDiffL2(2,:,:) )' );
hold on;
plot( [0, nObjs * (nObjs-1)], [minDiffL2, minDiffL2], '--k' );
plot( [0, nObjs * (nObjs-1)], [maxDiffL2, maxDiffL2], ':k' );
ylabel('L^2 difference');
%ylabel(sprintf('L^2 difference\n of difference'));
set(gca,'XTickLabel',labels)
rotateXLabels( gca(), 45 );
title('Bigger, L^2 norm (objects)');


subplot(nRows,nCols,7);
boxplot( squeeze( compareWiggleL2Dff(1,:,:) )' );
hold on;
plot( [0, nObjs], [minDiffL2, minDiffL2], '--k' );
plot( [0, nObjs], [maxDiffL2, maxDiffL2], ':k' );
set(gca,'XTickLabel',names)
ylabel(sprintf('L^2 difference\n of difference'));
rotateXLabels( gca(), 45 );
title('Small noise, L^2 diff norm');

subplot(nRows,nCols,8);
boxplot( squeeze( compareWiggleL2Dff(2,:,:) )' );
hold on;
plot( [0, nObjs], [minDiffL2, minDiffL2], '--k' );
plot( [0, nObjs], [maxDiffL2, maxDiffL2], ':k' );
set(gca,'XTickLabel',names)
ylabel(sprintf('L^2 difference\n of difference'));
rotateXLabels( gca(), 45 );
title('Biger noise, L^2 diff norm');

fname = 'Images/WiggleGraphsII.pdf';
saveGraphics(fname,[1080,2080]);

