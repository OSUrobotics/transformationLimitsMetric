%Converts matrices of vectors into matrices of unit vectors
function [ vectorOut ] = normalize( vectorIn )
height = size(vectorIn,1);
vectorOut = zeros(size(vectorIn));
for index = 1:height
    vectorOut(index,:) = vectorIn(index,:)/norm(vectorIn(index,:));
end
end