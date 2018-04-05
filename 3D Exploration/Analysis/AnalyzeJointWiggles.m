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
%% If not already loaded, load the transformation values
if ~exist('transformationStruct','var')
    strTag = input('Which transformation (eg _10_5_3_8):');
    transformationsFilename = strcat( 'transformationStoredJoint', strTag );
    %% If not already created, create the file
    if ~exist(transformationsFilename,'file')
        fprintf('That transfromation does not exist %s\n', transformationsFilename);
    else
        load(transformationsFilename);
        disp('Loaded transformations');
    end
else
    fprintf('Using preloaded transformations %s\n', transformationsFilename);
end

%% Loop through the items in the handObjectLinking list
nWiggles = 20;
nNoiseLevels = 5;
nDirs = transformationStruct.numTranslationDirections * ...
    transformationStruct.numRotationAxes * ...
    length(transformationStruct.angleDivisions);
data = zeros( nNoiseLevels, nWiggles, nDirs, transformationStruct.numInterpolationSteps - 1 );
dataDiffs = zeros( nNoiseLevels, nWiggles, nDirs, transformationStruct.numInterpolationSteps - 1 );
nVals = nDirs * (transformationStruct.numInterpolationSteps - 1);
for noiseLevel = 1:nNoiseLevels
    
    
    %% Loop through the items in the handObjectLinking list
    for n = 0:19
        fname = sprintf('../NoiseyMovements/OutputJointWiggle/T%s_perc%0.0f_%0.0f.csv', strTag, noiseLevel, n );
        dataWiggle = table2array(readtable(fname));
        data(noiseLevel, n+1, :,:) = dataWiggle(:, 8:end);
        for k = 1:nDirs
            seq = [0, squeeze( data( noiseLevel, n+1, k, 1:end-1 ) )' ];
            dataDiffs(noiseLevel, n+1, k, :) = squeeze( data( noiseLevel, n+1, k, : ) ) - seq';
        end
    end
end

%% Pairwise comparisons
compareDiffL2 = zeros( nNoiseLevels, nWiggles * (nWiggles-1) );
compareDiffL2Dff = zeros( nNoiseLevels, nWiggles * (nWiggles-1) );
compareWiggleL2 = zeros( nNoiseLevels, nWiggles * (nWiggles-1) );
compareWiggleL2Dff = zeros( nNoiseLevels, nWiggles * (nWiggles-1) );

nCountDiff = 1;
for noiseLevel = 1:nNoiseLevels
    nCountDiff = 1;
    nCountWiggle = 1;
    diffsL2 = zeros( nWiggles, nWiggles );
    diffsL2Diff = zeros( nWiggles, nWiggles );
    for w1 = 1:nWiggles
        for w2 = w1+1:nWiggles
            diffsL2(w1, w2) = sqrt( sum( sum( squeeze( data(noiseLevel,w1,:,:) - data(noiseLevel,w2,:,:) ).^2 ) ) ) / nVals;
            diffsL2Diff(w1, w2) = sqrt( sum( sum( squeeze( dataDiffs(noiseLevel,w1,:,:) - dataDiffs(noiseLevel,w2,:,:) ).^2 ) ) ) / nVals;

            compareDiffL2(noiseLevel, nCountDiff) = diffsL2(w1, w2);
            compareDiffL2Dff(noiseLevel, nCountDiff) = diffsL2Diff(w1, w2);
            nCountDiff = nCountDiff + 1;
        end
    end

end

figure(1)
clf;
nRows = 1;
nCols = 2;

subplot(nRows,nCols,1);
histogram( compareDiffL2 );
xlabel('L^2 difference');
ylabel('Number');
%legend( 'Different', 'Wiggled' );
title({'L^2 metric'},{'Joint angle'} );

subplot(nRows,nCols,2);
histogram( compareDiffL2Dff );

xlabel('L^2 diff of differences');
ylabel('Number');
%legend( 'Different', 'Wiggled' );
title({'L^2 diff metric'}, {'Joint angle'} );

fname = sprintf('Images/JointWiggleGraphs%s.pdf', strTag);
saveGraphics(fname,[7,7]);

