function [ outputMatrix ] = makeTransformationValues( sphereComplexity, angleVariance )
%MAKETRANSFORMATIONVALUES Summary of this function goes here
%   Detailed explanation goes here
%% Make the translation vectors using a uniform sphere
vectorSphere = IcosahedronMesh;
vectorSphere = SubdivideSphericalMesh(vectorSphere,sphereComplexity);
translateVectors = vectorSphere.vertices';
%% Make the angle vectors by using a equally distributed variance of degrees
alpha = 0:angleVariance:360;
beta = 0:angleVariance:360;
gamma = 0:angleVariance:360;
angleRotations = combvec(alpha, beta, gamma)';
%% Combine them into the possible combinations
outputMatrix = combvec(translateVectors,angleRotations)';
end

