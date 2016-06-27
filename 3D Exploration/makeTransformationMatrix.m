function [ transformationMatrices ] = makeTransformationMatrix( transformationValues )
%MAKETRANSFORMATIONMATRIX Generates translation matrices from a set of points to transform from the origin to 
%   Inputs:
% xyzSphereComplexity & angleSphereComplexity: values defining the number of divisions applied to the Icosahedron to generate the points in a sphere for either the normal vectors for rotation or the directional vectors for translation
% angleDistribution: number of subdivisions of pi used in rotating the object on the plane defiend by the normal vector generated from the angle sphere, controled in complexity by the angleSphereComplexity
%% Make the translation vectors using a uniform sphere
moveSphere = IcosahedronMesh;
translateSphere = SubdivideSphericalMesh(moveSphere,xyzSphereComplexity);
translateVectors = translateSphere.vertices';
%% Make a set of normal vectors using a sphere
normalsSphere = SubdivideSphericalMesh(moveSphere,angleSphereComplexity);
normalVectors = normalsSphere.vertices';
%% Make the angle values for the angle rotation
angleRotations = -pi:(2*pi)/angleDistribution:pi;
%% Combine them into the possible combinations
outputMatrix = combvec(translateVectors,normalVectors,angleRotations)';
%% Convert those to transformation matrices
transformationMatrices = zeros(4,4,size(outputMatrix,1));
for index = 
end

