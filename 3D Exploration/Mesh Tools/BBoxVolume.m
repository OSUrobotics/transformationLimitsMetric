function [ volume ] = BBoxVolume( points )
%BBoxVolume Get the bounding sphere volume of the points
%   Use sphere so that not orientation dependent

  center = getCentroidMesh( points );
for k = 1:3
	  points(:,k) = points(:,k) - center(k);
end
points = points.^2;
radii = sqrt( points(:,1) + points(:,2) + points(:,3) );

volume = 4 * max(radii).^3 * pi / 3;
end

