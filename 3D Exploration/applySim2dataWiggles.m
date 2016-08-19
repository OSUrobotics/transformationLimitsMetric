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
transformationSettings.handAndObjectScalar = 1;
transformationSettings.translateScalar = 1;
transformationSettings.numTranslationDirections = 12;
transformationSettings.numRotationAxes = 7;
transformationSettings.angleDivisions = [-1 -.5 -.25 0 .25 .5 1];
transformationSettings.numInterpolationSteps = 10;
%% Load in the wiggles
load('wigglesStored.mat');
%% Other variables
originToCenter = -[0 0 0.085/2+0.08]; % Half of the height of a fingers touching position to the palm, plus the palm-origin offset
handSpreadDistance = 0.385; % Hand setting for scaling
objectVoxelResolution = 50;
handVoxelResolution = 100;
pmDepth = 4;
pmScale = 1;
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
%% Loop through the items in the handObjectLinking list
for pairingIndex = [5 7 23 65]
    [standardOV,standardOF] = stlRead(handObjectLinking{pairingIndex,2});
    [standardOSV,~] = read_ply(handObjectLinking{pairingIndex,3});
    %% Load and normalize with loadHandObject
    [handV,handF,objectV,objectSV] = loadHandObject(handObjectLinking{pairingIndex,4}, ... 
                                                    originToCenter,handObjectLinking{pairingIndex,1},standardOV,standardOSV, ... 
                                                    handSpreadDistance,transformationSettings.handAndObjectScalar);
    disp('Loaded object and hand and surfacepoints, transformed to origin');
    %% Add in the wiggle transformations
    objectVW = applyWiggles(objectV,wiggles);
    objectSVW = applyWiggles(objectSV,wiggles);
    %% Loop through the wiggles and apply
    for wIndex = 1:size(wiggles,2)
        objectV = objectVW(:,:,wIndex);
        objectSV = objectSVW(:,:,wIndex);
        %% Generate voxels for passing into runSimFun
        handVox = getVoxelValues(handV,handF,handVoxelResolution);
        objectVox = getVoxelisedVerts(objectV,standardOF,objectVoxelResolution);
        disp('Generated voxels');
        %% And surface area
        surfArea = trimeshSurfaceArea(objectV,standardOF);
        disp('Calculated surface area');
        %% Run script on it all
        runSimFun(transformationStruct,objectVox,objectSV,handVox,objectVoxelResolution,surfArea,sprintf(handObjectLinking{pairingIndex,9},wIndex,'%i'));
        fprintf('Done with loop index %i/%i\n\n',pairingIndex,size(handObjectLinking,1))
    end
end