function realignObject( inputPath, outputPath, handPath )
%% REALIGNSTL Allows the user to edit an STL 
%
%
%
%==========================================================================

%% Load Object
[objectV,objectF] = read_ply(inputPath); % Gives vertical vertices matrix,association matrix
objectVpad = [objectV ones(size(objectV,1),1)]; % Pad the points list with ones to work with 4x4 transformation matrices
objectVpad = objectVpad*(makehgtform('translate',-getCentroidMesh(objectV)).'); % Translate the object to origin
objectVpad = objectVpad*(makehgtform('scale',1/max(abs(objectV(:)))).'); % Scale the object to one,then to the scaleFactor inputted
objectV = objectVpad(:,1:3); % Remove padding
%% Load the hand and scale to origin
[handV,handF,~,~] = stlRead(handPath); % Same as above
handVpad = [handV ones(size(handV,1),1)];
handVpad = handVpad*(makehgtform('translate',-getCentroidMesh(handV)).');
handVpad = handVpad*(makehgtform('scale',1/max(abs(handV(:)))).');
handV = handVpad(:,1:3);
%% LOOP!!!
while 1
    clf;
    stlPlot(objectV,objectF,false);
    stlPlot(handV,handF,false,'Object & Hand');
    camlight('headlight');
    material('dull');
    in = input('Do you want to edit the object pos? Y/N [N]: ','s');
    if isempty(in)%Default to no if no input is given
        in = 'N';
    end
    if in == 'Y'
        %% Handle repositioning
        rotateXIn = input('X Rotate [0]: ');
        rotateYIn = input('Y Rotate [0]: ');
        rotateZIn = input('Z Rotate [0]: ');
        translateXIn = input('X Translate [0]: ');
        translateYIn = input('Y Translate [0]: ');
        translateZIn = input('Z Translate [0]: ');
        scaleXIn = input('X Scale [1]: ');
        scaleYIn = input('Y Scale [1]: ');
        scaleZIn = input('Z Scale [1]: ');
        %Apply default values
        if isempty(rotateXIn)
            rotateXIn = 0;
        end
        if isempty(rotateYIn)
            rotateYIn = 0;
        end
        if isempty(rotateZIn)
            rotateZIn = 0;
        end
        if isempty(translateXIn)
            translateXIn = 0;
        end
        if isempty(translateYIn)
            translateYIn = 0;
        end
        if isempty(translateZIn)
            translateZIn = 0;
        end
        if isempty(scaleXIn)
            scaleXIn = 1;
        end
        if isempty(scaleYIn)
            scaleYIn = 1;
        end
        if isempty(scaleZIn)
            scaleZIn = 1;
        end
        %Apply transformation to temporary meshes
        tempObjectV = objectVpad*(makehgtform(...
                      'translate',[translateXIn,translateYIn,translateZIn],...
                      'scale',[scaleXIn,scaleYIn,scaleZIn],...
                      'xrotate',deg2rad(rotateXIn),...
                      'yrotate',deg2rad(rotateYIn),...
                      'zrotate',deg2rad(rotateZIn)).');
        %Draw new positions
        tempObjectV = tempObjectV(:,1:3); % Remove padding
        clf;
        stlPlot(tempObjectV,objectF,false);
        stlPlot(handV,handF,false,'Is this OK?');
        camlight('headlight');
        material('dull');
        %Confirm
        while 1
            in2 = input('Is this OK? Y/N [Y]: (vX,vY,vZ to view axis)','s');
            if isempty(in2)
                in2 = 'Y';
            end
            if in2 == 'Y'
                disp('Writing file...');
                write_ply(tempObjectV,objectF,outputPath);
                break;
            end
            if strcmp(in2, 'vX')
                view([1,0,0]);
            end
            if strcmp(in2, 'vY')
                view([0,1,0]);
            end
            if strcmp(in2, 'vZ')
                view([0,0,1]);
            end
            if in2 == 'N'
                break;
            end
        end
    if in2 == 'Y'
        break;
    end;
    elseif in ~= 'N'
        disp('Huh?');
    else
        disp('Writing file...');
        write_ply(objectV,objectF,outputPath);
        break;
    end    
end
end

