%Returns a matrix for translating by (x, y) units
function m = matrixTranslate(x, y)
%Start w/ identity
m = eye(3, 3);
%Set x-distance
m(1, 3) = x;
%Set y-distance
m(2, 3) = y;
end