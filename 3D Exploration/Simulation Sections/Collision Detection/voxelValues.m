function [ voxels ] = voxelValues( v,f,resolution )
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
%       resolution  - Mandatory - Decimal value     -Value dictating the number of voxels along the maximum dimension of the mesh
%
% OUTPUTS
%
%       voxels      - Mandatory - Nx4 array         -List of voxels where N is the number of points sampled and the 4 columns are their x, y, and z coordinates and v, the voxel value at that location
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
dimRanges = [range(fv.vertices(:,1)),range(fv.vertices(:,2)),range(fv.vertices(:,3))];
%Scale based on resolution
voxInputs = floor(resolution/max(dimRanges)*dimRanges);
%% Use VOXELISE to get a logical array of voxels
OUT = VOXELISE(voxInputs(1),voxInputs(2),voxInputs(3),fv,'xyz');
%% Convert to points in 3D space and readjust to fit original geometry
%Set x y and z index values, and put in a vector
indices = repmat((1:length(OUT(:))).',[1 3]);
%Move to a zero index
indices = indices -1;
%Convert verts back to their original scale
%% Get index ranges
indexRanges = range(indices);
%% Devide the values by the ranges
indexRanges = repmat(indexRanges,size(indices(:,1), 1),1);
indices = indices ./ indexRanges;
%% Multiply by the new scale and account for difference between center and edge of voxel
dimRanges = dimRanges - (max(dimRanges(:))/resolution)*2.1;
dimRanges = repmat(dimRanges,size(indices(:,1), 1),1);
voxels = indices .* dimRanges;
%% Center on orgin
voxels = translateMesh(voxels, [-1,0,0], range(xindices)/2);
voxels = translateMesh(voxels, [0,-1,0], range(yindices)/2);
voxels = translateMesh(voxels, [0,0,-1], range(zindices)/2);
%% Translate to object
center = getBBcenter(v);
thisCenter = getBBcenter(voxels);
difference = center - thisCenter;
voxels = translateMesh(voxels, difference, norm(difference));
end