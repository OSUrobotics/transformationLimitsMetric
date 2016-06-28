function [ output ] = getVoxelisedVerts( v,f,resolution )
%GENERATETRANSLATIONVECTORS Takes a mesh and converts it to a voxel volume
%   Returns a Nx3 array of points that are inside the mesh defined by v and
%   f.  The number of points is dertermined by resolution, with higher
%   resolutions yielding higher N values.

%Add v and f to a struct
fv.vertices = v;
fv.faces = f;
%Calculate the dimensions of the object
xRange = range(fv.vertices(:,1));
yRange = range(fv.vertices(:,2));
zRange = range(fv.vertices(:,3));
%Scale based on resolution
xRes = floor(xRange * resolution);
yRes = floor(yRange * resolution);
zRes = floor(zRange * resolution);
%VOXELISE into a logical array
OUT = VOXELISE(xRes,yRes,zRes,fv,'xyz');
%Set x y and z index values
[xIndeces,yIndeces,zIndeces] = ind2sub(size(OUT),find(OUT));
%Move to a zero index
xIndeces = xIndeces-1;
yIndeces = yIndeces-1;
zIndeces = zIndeces-1;
%Convert verts back to their original scale
%Get index ranges
xIRange = range(xIndeces);
yIRange = range(yIndeces);
zIRange = range(zIndeces);
%Devide the values by the ranges
xIndeces = xIndeces / xIRange;
yIndeces = yIndeces / yIRange;
zIndeces = zIndeces / zIRange;
%Multiply by the new scale
xIndeces = xIndeces * xRange;
yIndeces = yIndeces * yRange;
zIndeces = zIndeces * zRange;
%Assign to vector
output = [xIndeces yIndeces zIndeces];
%Center on orgin
output = translateMesh(output, [-1,0,0], range(xIndeces)/2);
output = translateMesh(output, [0,-1,0], range(yIndeces)/2);
output = translateMesh(output, [0,0,-1], range(zIndeces)/2);
%Translate to object
center = getBBcenter(v);
thisCenter = getBBcenter(output);
difference = center - thisCenter;
output = translateMesh(output, difference, norm(difference));


% Graph for now
% clf;
% scatter3(output(:,1),output(:,2),output(:,3), '.r');
% axis image;
end


