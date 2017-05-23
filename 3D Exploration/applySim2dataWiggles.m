%% This script calls runSimulation over a large number of hands and transformations
disp('Started script');
%% Dealing with parpool
% p = gcp('nocreate');
% if isempty(p)
%     parpool(4);
%     p = gcp();
% end
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

dirs = {'Small', 'Large'};
locs = [0.0125, 0.025];
angs = [pi/64, pi/32];

nWiggles = 6;
names = {'Bottle body', 'Bottle top', 'Glass', 'Box', 'Cylinder', 'Ball'};

for amnt = 1:length(locs)
    
    %% Store percentage of movement relative to object and hand size
    percMoved = struct;
    percMoved.PairingIndex = find( table2array( cell2table(handObjectLinking(:,9)) ) == 1 );
    percMoved.ObjectMove = zeros( length( percMoved.PairingIndex), nWiggles );
    percMoved.HandMove = zeros( length( percMoved.PairingIndex), nWiggles );
    percMoved.WhichObj = cell(length( percMoved.PairingIndex), 1);
    percMoved.WhichGrasp = cell(length( percMoved.PairingIndex), 1);
    percMoved.Wiggles = zeros( length( percMoved.PairingIndex), 7, nWiggles );
    wiggles = zeros( 7, nWiggles );
    
    %% Loop through the items in the handObjectLinking list
    obj = 1;
    for pairingIndex = percMoved.PairingIndex'
        [standardOV,standardOF] = stlRead(handObjectLinking{pairingIndex,2});
        [standardOSV,~] = read_ply(handObjectLinking{pairingIndex,3});
        % Save which hand/grasp
        percMoved.WhichObj{obj,1} = handObjectLinking{pairingIndex,2};
        percMoved.WhichGrasp{obj,1} = handObjectLinking{pairingIndex,3};
        %% Load and normalize with loadHandObject
        [handV,handF,objectV,objectSV] = loadHandObject(handObjectLinking{pairingIndex,4}, ...
            originToCenter,handObjectLinking{pairingIndex,1},standardOV,standardOSV, ...
            handSpreadDistance,transformationSettings.handAndObjectScalar);
        fprintf('Loaded object and hand %s and surfacepoints, transformed to origin\n',handObjectLinking{pairingIndex,10} );

        clf;
        stlPlotWColor( handV, handF, false, strcat('Wiggle ', dirs{amnt}, names{obj}), 0.001 );
        hold on;
        stlPlotWColor( objectV, standardOF, false, sprintf('Wiggle %s %s', dirs{amnt}, names{obj}), 0.0 );
        addLight;

        % Save
        objectVSave = objectV;
        
        %% Add in the wiggle transformations
        nWiggles = size( wiggles, 2 );
        
        % Volume of object
        radiiHand = RadiiBoundingSphere( handV );
        radiiObject = RadiiBoundingSphere( objectV );
        
        dTrans = locs(amnt);
        phi = rand(nWiggles, 1) * pi - pi/2;
        theta = rand( nWiggles, 1) * 2 * pi;
        wiggles( 1,: ) = cos( theta ) .* cos(phi) * radiiObject * dTrans;
        wiggles( 2,: ) = sin( theta ) .* cos(phi) * radiiObject * dTrans;
        wiggles( 3,: ) = sin(phi) * radiiObject * dTrans;
        
        phi = rand(nWiggles, 1) * pi - pi/2;
        theta = rand( nWiggles, 1) * 2 * pi;
        wiggles( 4,: ) = cos( theta ) .* cos(phi);
        wiggles( 5,: ) = sin( theta ) .* cos(phi);
        wiggles( 6,: ) = sin(phi);
        wiggles( 7,:) = angs(amnt);
        
        percMoved.Wiggles(obj,:,:) = wiggles;
        
        % Move our object to its center
        ptCenter = getCentroidMesh( objectV );
        for k = 1:3
            objectV(:,k) = objectV(:,k) - ptCenter(k);
            objectSV(:,k) = objectSV(:,k) - ptCenter(k);
        end
        % Apply translation and rotation for each wiggle
        objectVW = applyWiggles(objectV,wiggles);
        objectSVW = applyWiggles(objectSV,wiggles);
        
        % Pre-calculate
        %% Generate voxels for passing into runSimFun
        handVox = getVoxelValues(handV,handF,handVoxelResolution);
        disp('Generated voxels');
        %% And surface area
        surfArea = trimeshSurfaceArea(objectV,standardOF);
        disp('Calculated surface area');
        
        %% Loop through the wiggles and apply
        for wIndex = 1:size(wiggles,2)
            % Get the moved object from our saved list
            objectV = objectVW(:,:,wIndex);
            objectSV = objectSVW(:,:,wIndex);
            % Undo our translation to the origin
            for k = 1:3
                objectV(:,k) = objectV(:,k) + ptCenter(k);
                objectSV(:,k) = objectSV(:,k) + ptCenter(k);
            end
            
            %% Relative movement
            objShift = objectV - objectVSave;
            objMoved = sum( sqrt( objShift(:,1).^2 + objShift(:,2).^2 + objShift(:,3).^2 ) ) / size( objShift, 1);
            percMoved.ObjectMove(obj, wIndex) = objMoved / radiiObject;
            percMoved.HandMove(obj, wIndex) = objMoved / radiiHand;
            
            %% Generate voxels for passing into runSimFun
            objectVox = getVoxelisedVerts(objectV,standardOF,objectVoxelResolution);
            disp('Generated voxels');

            plot3( objectV(:,1), objectV(:,2), objectV(:,3), '+g')
            
            %% Run script on it all
            fname = strcat('OutputWiggle', dirs{amnt}, '/', sprintf(handObjectLinking{pairingIndex,10},wIndex,'%i') );
            runSimFun(transformationStruct,objectVox,objectSV,handVox,objectVoxelResolution,surfArea,fname);
            fprintf('Done with loop index %i/%i\n\n',pairingIndex,size(handObjectLinking,1))
        end
        
        % Next object
        fname = sprintf( sprintf(handObjectLinking{pairingIndex,10},wIndex,'%i'), 0 );
        fnameShort = fname(13:end-20);
        fname = sprintf('Images/Wiggle_%s%s.jpg',fnameShort, dirs{amnt});
        saveGraphics(fname,[1080,1080]);
        obj = obj + 1;
    end
    
    fname = sprintf('OutputWiggle%s/wiggleTest.mat', dirs{amnt});
    save( fname, 'percMoved')
end
