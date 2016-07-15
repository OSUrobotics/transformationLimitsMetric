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
ranges = [range(fv.vertices(:,1)),range(fv.vertices(:,2)),range(fv.vertices(:,3))];
center = getBBcenter(v);
mins = min(v);
maxs = max(v);
%Scale based on resolution
voxInputs = floor(resolution/max(ranges)*ranges);
steps = ranges./voxInputs;
%% Use VOXELISE to get a logical array of voxels
OUT = VOXELISE(voxInputs(1),voxInputs(2),voxInputs(3),fv,'xyz');
%% Convert to points in 3D space and readjust to fit original geometry
%Set x y and z index values, and put in a vector
[voxelX, voxelY, voxelZ] = meshgrid(linspace((mins(1)+0.5*steps(1)),(maxs(1)-0.5*steps(1)),voxInputs(1)), ... 
                                    linspace((mins(2)+0.5*steps(2)),(maxs(2)-0.5*steps(2)),voxInputs(2)), ...
                                    linspace((mins(3)+0.5*steps(3)),(maxs(3)-0.5*steps(3)),voxInputs(3)));
voxels = cat(4,voxelX,voxelY,voxelZ,permute(OUT,[2 1 3]));
end