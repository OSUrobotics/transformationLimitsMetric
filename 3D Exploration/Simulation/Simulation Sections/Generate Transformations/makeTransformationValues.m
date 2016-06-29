function [ outputMatrix ] = makeTransformationValues( directionPoints, orientationPoints, angleDistribution )
%%MAKETRANSFORMATIONVALUES Takes complexity values and generates a list of directional vectors and axes for rotation around, with rotation values 
%% Make the translation vectors using a uniform sphere
translateSphere = SpiralSampleSphere(directionPoints);
translateVectors = translateSphere.vertices';
%% Make a set of normal vectors using a sphere
normalsSphere = SpiralSampleSphere(orientationPoints);
normalVectors = normalsSphere.vertices';
%% Make the angle values for the angle rotation
angleRotations = -pi:(2*pi)/angleDistribution:pi;
%% Combine them into the possible combinations
outputMatrix = combvec(translateVectors,normalVectors,angleRotations);
end