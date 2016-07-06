%Returns a matrix for rotating by (theta) degrees
function m = matrixRotate( theta )
%Start w/ identity
m = eye(3, 3);
%Declare rotation values

m(1, 1) = cosd(theta);
m(1, 2) = sind(theta);
m(2, 1) = -sind(theta);
m(2, 2) = cosd(theta);
end