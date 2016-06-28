function [ transformationMatrices ] = makeTransformationMatrix( transformationValues )
%MAKETRANSFORMATIONMATRIX Generates translation matrices from a set of points to transform from the origin
%% Initialize container and loop through input values
transformationMatrices = zeros(4,4,size(transformationValues,1));
for index = 1:size(transformationValues,1)
    transformationMatrices(:,:,index) = makehgtform('translate',transformationValues(index,1:3),'axisrotate',transformationValues(index,4:6),transformationValues(index,7));
end
end