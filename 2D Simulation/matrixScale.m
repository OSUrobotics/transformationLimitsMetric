%Returns a matrix for scaling by (scale x, scale y) units
function m = matrixScale(sx, sy)
%Start w/ identity
m = eye(3, 3);
%Set scale x & y values
m(1, 1) = sx;
m(2, 2) = sy;
end