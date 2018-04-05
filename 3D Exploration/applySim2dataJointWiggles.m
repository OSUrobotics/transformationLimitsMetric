%% This script calls runSimulation over a large number of hands and transformations
disp('Started script');
addpath '/Users/grimmc/Code/GraspingMetric';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Analysis';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Readers and Visualizations';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Mesh Tools';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Mesh Tools/File Readers';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Simulation Sections';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Simulation Sections/Collision Detection';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Simulation Sections/Collision Detection/Dependencies';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Simulation Sections/Generate Transformations';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Simulation Sections/Generate Transformations/Wiggles';
addpath '/Users/grimmc/Code/GraspingMetric/3D exploration/Simulation Sections/Generate Transformations/Dependencies';
%% Dealing with parpool
% p = gcp('nocreate');
% if isempty(p)
%     parpool(4);
%     p = gcp();
% end
%% Declaring transformation settings variables
transformationSettings = struct;
transformationSettings.handAndObjectScalar = 1;
transformationSettings.translateScalar = 1;
% transformationSettings.numTranslationDirections = 10;
% transformationSettings.numRotationAxes = 7;
% transformationSettings.angleDivisions = [-.5 -.25 0 .25 .5];
transformationSettings.numTranslationDirections = 18;
transformationSettings.numRotationAxes = 7;
transformationSettings.angleDivisions = [-.5 0 .5];
% transformationSettings.numTranslationDirections = 28;
% transformationSettings.numRotationAxes = 7;
% transformationSettings.angleDivisions = [-.5 0 .5];
transformationSettings.numInterpolationSteps = 8;

strTag = TagForTransformation( transformationSettings );
transformationsFilename = strcat( 'transformationStoredJoint', strTag );

fprintf('ApplySimTdataJointWiggles started, %s\n', strTag);

%% Other variables
originToCenter = -[0 0 0.085/2+0.08]; % Half of the height of a fingers touching position to the palm, plus the palm-origin offset
handSpreadDistance = 0.385; % Hand setting for scaling
objectVoxelResolution = 50;
handVoxelResolution = 100;
pmDepth = 4;
pmScale = 1;
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

dirs = cell(5,1);
for k = 1:5
    dirs{k} = sprintf('%0.0fPercentNoise', k);
end

names = {'Bottle top'};

transFile = '../NoiseyMovements/noTransformation.txt';

obj = 1;
[standardOV,standardOF] = stlRead( '../NoiseyMovements/sprayBottle.stl' );
[standardOSV,~] = read_ply( '../NoiseyMovements/sprayBottle_P.ply' );
standardOV = standardOV .* 1000;

clf
stlPlotWColor( standardOV, standardOF, false, 'Joint wiggle', 0.0 );
hold on;
plot3( standardOSV(:,1), standardOSV(:,2), standardOSV(:,3), '.g');

%% Generate voxels for passing into runSimFun
objectVox = getVoxelisedVerts(standardOV,standardOF,objectVoxelResolution);
disp('Generated voxels');

for noiseLevel = 1:length(dirs)
    
    
    %% Loop through the items in the handObjectLinking list
    for n = 0:19
        %% Load and normalize with loadHandObject
        strHandSTL = sprintf('../NoiseyMovements/%s/noise_grasp%0.0f.stl', dirs{noiseLevel}, n);
        [handV,handF,objectV,objectSV] = loadHandObject(strHandSTL, ...
            originToCenter,transFile,standardOV,standardOSV, ...
            handSpreadDistance,transformationSettings.handAndObjectScalar);
        fprintf('Loaded object and hand %s and surfacepoints, transformed to origin\n',strHandSTL );

        clf;
        stlPlotWColor( handV, handF, false, strcat('Joint wiggle ', dirs{noiseLevel}), 0.001 );
        hold on;
        stlPlotWColor( objectV, standardOF, false, sprintf('Joint wiggle %s', dirs{noiseLevel}), 0.0 );
        addLight;

        % Pre-calculate
        %% Generate voxels for passing into runSimFun
        handVox = getVoxelValues(handV,handF,handVoxelResolution);
        disp('Generated voxels');
        %% And surface area
        surfArea = trimeshSurfaceArea(objectV,standardOF);
        disp('Calculated surface area');
        
        %% Loop through the wiggles and apply


        %% Run script on it all
        fname = sprintf('../NoiseyMovements/OutputJointWiggle/T%s_perc%0.0f_%0.0f.csv', strTag, noiseLevel, n );
        %fname = strcat('OutputWiggle', dirs{amnt}, '/', sprintf(handObjectLinking{pairingIndex,10},wIndex) );
        runSimFun(transformationStruct,objectVox,objectSV,handVox,objectVoxelResolution,surfArea,fname);
        fprintf('Done with loop index %i/%i\n\n',noiseLevel, n);
        
    end
    
end
