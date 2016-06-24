function [ output ] = getVoxelisedVerts( v,f,resolution )
%Takes vertices and faces of a mesh and converts it to a list of voxel
%points

%Add v and f to a struct
fv.vertices = v;
fv.faces = f;
%Calculate the dimensions of the object
xRange = range(fv.vertices(:,1));
yRange = range(fv.vertices(:,2));
zRange = range(fv.vertices(:,3));
%Scale based on resolution
xRes = ceil(xRange * resolution);
yRes = ceil(yRange * resolution);
zRes = ceil(zRange * resolution);
%VOXELISE into a logical array
OUT = VOXELISE(xRes,yRes,zRes,fv,'xyz');
%Set x y and z index values
[xIndeces,yIndeces,zIndeces] = ind2sub(size(OUT),find(OUT));
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


output = [xIndeces yIndeces zIndeces];
end


