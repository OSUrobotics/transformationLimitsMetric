function [ verticesOut ] = rotateMeshEuler( verticesIn, alpha, beta, gamma )
%ROTATEMESHEULER using xyz euler rotational vectors, rotates the given set of points by that much
%   Uses Eul2rotm to generate a rotation matrix and applies the rotation matrix to the points
verticesOut = eul2rotm([alpha,beta,gamma])*verticesIn;
end

