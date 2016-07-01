function [ outputMatrix ] = makeTransformationValuesOld( xyzSphereComplexity, angleSphereComplexity, angleDistribution)
%MAKETRANSFORMATIONVALUESOLD Summary of this function goes here
%   Detailed explanation goes here
%% Make the translation vectors using a uniform sphere
translateSphere = IcosahedronMesh;
translateSphere = SubdivideSphericalMesh(translateSphere,xyzSphereComplexity);
translateVectors = translateSphere.vertices';
%% Make a set of normal vectors using a sphere
normalsSphere = IcosahedronMesh;
normalsSphere = SubdivideSphericalMesh(normalsSphere,angleSphereComplexity);
normalVectors = normalsSphere.vertices';
%% Make the angle values for the angle rotation
angleRotations = -pi:(2*pi)/angleDistribution:pi;
%% Combine them into the possible combinations
outputMatrix = combvec(translateVectors,normalVectors,angleRotations)';
end
