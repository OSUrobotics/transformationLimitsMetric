function visualizeTransformations( transformationMatrices, handV, handF, objectV, scaleAxes, collisionThreshhold )
%% VISUALIZETRANSFORMATIONS 
for tformIndex = 1:size(transformationMatrices,4)
    plotAxesArrows(transformationMatrices(:,:,:,tformIndex),.1);
end
%% If have hand, plot as well
if nargin >= 3
    stlPlot(handV,handF);
end
%% If have the vertices
if nargin == 4
    %% Make a colormap
    cmap = summer(size(objectV,3));
    %% Loop through values
    for valueIndex = 1:size(objectV,4)
        %% Loop through steps
        for stepIndex = 1:size(objectV,3)
            plot3(objectV(:,1,stepIndex,valueIndex),objectV(:,2,stepIndex,valueIndex),objectV(:,3,stepIndex,valueIndex),'.-','Color',cmap(stepIndex,:));
        end
    end
end