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
transformationSettings.objectScaleFactor = 5;
transformationSettings.handScaleFactor = 15;
transformationSettings.translateScalar = 20;
transformationSettings.numTranslationDirections = 10;
transformationSettings.numRotationAxes = 5;
transformationSettings.angleDivisions = [-1 -.5 -.25 0 .25 .5 1];
transformationSettings.numInterpolationSteps = 10;
%% Other variables
originToPalmVector = [0 0 4];
handSpreadDistance = .385;
voxelResolution = 50;
pmDepth = 4;
pmScale = 1;
handObjectLinkingFilePath = 'pathMapping.csv';
outputFilePath = 'Output/Obj%iStep%iAreaIntersection.csv';
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
[standardOV,standardOF] = read_ply(handObjectLinking{1,2});
%% Loop through the items in the handObjectLinking list
for pairingIndex = 2:size(handObjectLinking,2)
    %% If using the same object, don't load a new one
    if handObjectLinking{pairingIndex-1,2} ~= handObjectLinking{pairingIndex,2}
        [standardOV,standardOF] = read_ply(handObjectLinking{pairingIndex,2});
    end
    %% Load and normalize with loadHandObject
    [handV,handF,objectV,~] = loadHandObject(handObjectLinking{pairingIndex,3},originToPalmVector,handObjectLinking{pairingIndex,1},standardOV,handSpreadDistance);
    %% Run script on it all
    runSimFun(transformationStruct,objectV,objectF,handV,handF,handObjectLinking{pairingIndex,4},voxelResolution,pmDepth,pmScale,outputFilePath)
end