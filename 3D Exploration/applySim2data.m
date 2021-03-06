%% This script calls runSimulation over a large number of hands and transformations
disp('Started script');
%% Dealing with parpool
% p = gcp('nocreate');
% if isempty(p)
%     parpool(7);
%     p = gcp();
% end
disp('Parpool started');
%% Declaring transformation settings variables
transformationsFilename = 'transformationV2Stored';
transformationSettings = struct;
transformationSettings.handAndObjectScalar = 1;
transformationSettings.translateScalar = 1;
transformationSettings.numTranslationDirections = 32;
transformationSettings.numRotationAxes = 8;
%transformationSettings.angleDivisions = [-1 -.5 -.25 0 .25 .5 1];
transformationSettings.angleDivisions = [-1 0 1];
transformationSettings.numInterpolationSteps = 2;
transformationSettings.stepDiv = 0.025;
%% Other variables
originToCenter = -[0 0 0.085/2+0.08]; % Half of the height of a fingers touching position to the palm, plus the palm-origin offset
handSpreadDistance = 0.385; % Hand setting for scaling
objectVoxelResolution = 50;
handVoxelResolution = 100;
pmDepth = 4;
pmScale = 1;
handObjectLinkingFilePath = 'pathMapping.csv';
%% If not already loaded, load the transformation values
if ~exist('transformationStruct','var')
    %% If not already created, create the file
    if ~exist( strcat(transformationsFilename, '.mat'),'file')
        disp('Started generating transformations');
        transformationStruct = saveTrajectoriesV2(transformationSettings,transformationsFilename);
        disp('Done generating transformations');
    else
        load(strcat(transformationsFilename, '.mat'));
        disp('Loaded transformations');
    end
else
    disp('Using preloaded transformations');
end
%% Load in file relations between hand settings, object, and transformations, create if not created
if exist(handObjectLinkingFilePath,'file')
    handObjectLinking = table2cell(readtable(handObjectLinkingFilePath));
else
    handObjectLinking = linkFilenames(handObjectLinkingFilePath, 15); %Set to 15 for Saurabh's file format
end
disp('Loaded the hand-object-transformation linking csv');
%% Sort by object so don't load in unnecisarily many times, and run the first object in
handObjectLinking = sortrows(handObjectLinking, 2);
[standardOV,standardOF] = stlRead(handObjectLinking{1,2});
[standardOSV,~] = read_ply(handObjectLinking{1,3});
disp('Loaded first iteration of object');
%% Loop through the items in the handObjectLinking list
for pairingIndex = 1:size(handObjectLinking,1)
    %% If using the same object, don't load a new one
    if pairingIndex ~= 1 && ~strcmp(handObjectLinking{pairingIndex-1,2},handObjectLinking{pairingIndex,2})
        [standardOV,standardOF] = stlRead(handObjectLinking{pairingIndex,2});
        [standardOSV,~] = read_ply(handObjectLinking{pairingIndex,3});
    end
    %% Load and normalize with loadHandObject
    [handV,handF,objectV,objectSV] = loadHandObject(handObjectLinking{pairingIndex,4}, ... 
                                                    originToCenter,handObjectLinking{pairingIndex,1},standardOV,standardOSV, ... 
                                                    handSpreadDistance,transformationSettings.handAndObjectScalar);
    disp('Loaded object and hand and surfacepoints, transformed to origin');
    %% Generate voxels for passing into runSimFun
    handVox = getVoxelValues(handV,handF,handVoxelResolution);
    objectVox = getVoxelisedVerts(objectV,standardOF,objectVoxelResolution);
    disp('Generated voxels');
    %% And surface area
    surfArea = trimeshSurfaceArea(objectV,standardOF);
    disp('Calculated surface area');
    %% Run script on it all
    runSimFun(transformationStruct,objectVox,objectSV,handVox,objectVoxelResolution,surfArea,handObjectLinking{pairingIndex,9});
    fprintf('Done with loop index %i/%i\n\n',pairingIndex,size(handObjectLinking,1))
end