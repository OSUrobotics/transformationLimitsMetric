function [ voxels ] = getVoxelisedVerts( v,f,resolution )
%GENERATETRANSLATIONVECTORS Takes a mesh and converts it to a voxel volume
%==========================================================================
%
% USAGE
%       [ voxels ] = getVoxelisedVerts( v,f,resolution ) 
%
% INPUTS
%
%       v           - Mandatory - Nx3 array         -List of a mesh's vertex coordinates where N is the number of verteces 
%
%       f           - Mandatory - Nx3 array         -List of that mesh's face data where N is the number of faces
%       
%       resolution  - Mandatory - Decimal value     -Value dictating the density of output voxels where 1 yields 1 voxel per unit
%
% OUTPUTS
%
%       voxels      - Mandatory - Nx3 array         -List of voxels where N is the number of voxels and the 3 columns are their x, y, and z coordinates respectively
%
% EXAMPLE
%
%       To get the voxels of an STL file:
%       >>  [ voxels ] = getVoxelisedVerts( stlVerts, stlFaces, resolution )
%
% NOTES
%
%   -Mesh must be properly closed (ie. watertight)
%   -In most cases, any resolution greater than 1 is excessive
% 
% REFERENCES
%
%   -This code uses VOXELISE by Adam A.
%=========================================================================


%% Add v and f to a struct to be passed to VOXELISE
fv.vertices = v;
fv.faces = f;
%% Prepare Dimensions for VOXELISE
%Calculate the dimensions of the object
xRange = range(fv.vertices(:,1));
yRange = range(fv.vertices(:,2));
zRange = range(fv.vertices(:,3));
%Scale based on resolution
xRes = floor(xRange * resolution);
yRes = floor(yRange * resolution);
zRes = floor(zRange * resolution);
%% Use VOXELISE to get a logical array of voxels
OUT = VOXELISE(xRes,yRes,zRes,fv,'xyz');
%% Convert to points in 3D space and readjust to fit original geometry
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
voxels = [xIndeces yIndeces zIndeces];
%Center on orgin
voxels = translateMesh(voxels, [-1,0,0], range(xIndeces)/2);
voxels = translateMesh(voxels, [0,-1,0], range(yIndeces)/2);
voxels = translateMesh(voxels, [0,0,-1], range(zIndeces)/2);
%Translate to object
center = getBBcenter(v);
thisCenter = getBBcenter(voxels);
difference = center - thisCenter;
voxels = translateMesh(voxels, difference, norm(difference));
end


