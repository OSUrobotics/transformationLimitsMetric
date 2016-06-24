function [ verticesOut ] = rotateMeshEuler( verticesIn, alpha, beta, gamma )
%ROTATEMESHEULER Summary of this function goes here
%   Detailed explanation goes here
verticesOut = eul2rotm([alpha,beta,gamma])*verticesIn;

end

