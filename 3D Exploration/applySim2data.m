%% This script calls runSimulation over a large number of hands and transformations
disp('Started script');
%% Dealing with parpool
p = gcp('nocreate');
if isempty(p)
    parpool(7);
    p = gcp();
end
disp('Parpool started');
%% Declaring transformation settings variables
transformationsFilename = 'transformationStored';
transformationSettings = struct;
transformationSettings.handAndObjectScalar = 15;
transformationSettings.translateScalar = 20;
transformationSettings.numTranslationDirections = 10;
transformationSettings.numRotationAxes = 5;
transformationSettings.angleDivisions = [-1 -.5 -.25 0 .25 .5 1];
transformationSettings.numInterpolationSteps = 10;
%% Other variables
originToCenter = -[0 0 0.085/2+0.08]; % Half of the height of a fingers touching position to the palm, plus the palm-origin offset
handSpreadDistance = 0.385; % Hand setting for scaling
objectVoxelResolution = 50;
handVoxelResolution = 100;
pmDepth = 4;
pmScale = 1;
handObjectLinkingFilePath = 'pathMapping.csv';
outputFilePath = 'Output/Step%sObject%iSubject%iGrasp%i%sAreaIntersection.csv';
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
    handObjectLinking = linkHandObject(handObjectLinkingFilePath);
end
disp('Loaded the hand-object-transformation linking csv');
%% Sort by object so don't load in unnecisarily many times, and run the first object in
handObjectLinking = sortrows(handObjectLinking, 2);
[standardOV,standardOF] = stlRead(handObjectLinking{1,2});
[standardOSV,~] = read_ply(handObjectLinking{1,3});
%% Loop through the items in the handObjectLinking list
for pairingIndex = 2:size(handObjectLinking,2)
    %% If using the same object, don't load a new one
    if handObjectLinking{pairingIndex-1,2} ~= handObjectLinking{pairingIndex,2}
        [standardOV,standardOF] = read_ply(handObjectLinking{pairingIndex,2});
        [standardOSV,~] = read_ply(handObjectLinking{pairingIndex,3});
    end
    %% Load and normalize with loadHandObject
    [handV,handF,objectV,objectSV] = loadHandObject(handObjectLinking{pairingIndex,4},originToCenter,handObjectLinking{pairingIndex,1},standardOV,standardOSV,handSpreadDistance,transformationSettings.handAndObjectScalar);
    %% Generate voxels for passing in
    handVox = voxelValues(handV,handF,handVoxelResolution);
    objectVox = getVoxelisedVerts(objectV,standardOF,objectVoxelResolution);
    %% And surface area
    surfArea = trimeshSurfaceArea(objectV,standardOF);
    %% Run script on it all
    runSimFun(transformationStruct,objectVox,objectSV,handVox,objectVoxelResolution,surfArea,sprintf(outputFilePath,'%i',handObjectLinking{pairingIndex,5},handObjectLinking{pairingIndex,6},handObjectLinking{pairingIndex,7},handObjectLinking{pairingIndex,8}))
end