There are a large number of applications that rely on uniform sampling/decomposition of a sphere embedded in 3D space. This submission provides a set of functions that can be used to obtain a variety of different sampling patterns and decompositions of the spherical domain (see demo pic). 
Here is a brief summary of the main functions contained in this submission: 
------------------------------------------------------------------------------------------------------------------- 
'ParticleSampleSphere' : generates an approximately uniform triangular tessellation of a unit sphere by minimizing generalized electrostatic potential energy of a system of charged particles. By default, initializations are based on random sampling of a sphere, but user defined initializations are also permitted. Since the optimization algorithm implemented in this function has O(N^2) complexity, it is not recommended that 'ParticleSampleSphere' be used to optimize configurations of more than 1E3 particles. Resolution of the meshes obtained with this function can be increased to an arbitrary level with 'SubdivideSphericalMesh'.

------------------------------------------------------------------------------------------------------------------- 
'SubdivideSphericalMesh': increases resolution of triangular or quadrilateral spherical meshes. Given a base mesh, its resolution is increased by a sequence of k subdivisions. Suppose that No is the original number of mesh vertices, then the total number of vertices after k subdivisions will be Nk=4^k*No – 2*(4^k–1). This relationship holds for both triangular and quadrilateral meshes.

------------------------------------------------------------------------------------------------------------------- 
'IcosahedronMesh': generates a triangular mesh of an icosahedron. High-quality spherical meshes can be easily obtained by subdividing this base mesh with the 'SubdivideSphericalMesh' function.

------------------------------------------------------------------------------------------------------------------- 
'QuadCubeMesh': generates a quadrilateral mesh of a cube. High-quality spherical meshes can be easily obtained by subdividing this base mesh with the 'SubdivideSphericalMesh' function.

------------------------------------------------------------------------------------------------------------------- 
'SpiralSampleSphere': generates N uniformly distributed samples on a unit sphere using the technique described in http://blog.wolfram.com/2011/07/28/how-i-made-wine-glasses-from-sunflowers/

------------------------------------------------------------------------------------------------------------------- 
'RandSampleSphere': produces uniform random or stratified random sampling of a unit sphere.

EXAMPLE 1:

% Uniformly distribute 200 particles across the surface of a unit sphere. 
% This operation takes ~7 sec on my laptop (12GB RAM, 2.4 GHz processor) 
[V,Tri,~,Ue]=ParticleSampleSphere('N',200);

% Visualize optimization progress 
figure('color','w') 
plot(log10(1:numel(Ue)),Ue,'.-') 
set(get(gca,'Title'),'String','Optimization Progress','FontSize',40) 
set(gca,'FontSize',20) 
xlabel('log_{10}(Iteration #)','FontSize',30) 
ylabel('Electrostatic Potential','FontSize',30)

% Visualize the mesh based on the optimal configuration of particles 
figure('color','w') 
subplot(1,2,1) 
fv=struct('faces',Tri,'vertices',V); 
h=patch(fv); 
set(h,'EdgeColor','b','FaceColor','w') 
axis equal	
set(gca,'XLim',[-1.1 1.1],'YLim',[-1.1 1.1],'ZLim',[-1.1 1.1]) 
view(3) 
grid on 
set(get(gca,'Title'),'String','N=200 (base mesh)','FontSize',30)

% Subdivide base mesh twice to obtain a spherical mesh of higher complexity 
fv_new=SubdivideSphericalMesh(fv,2); 
subplot(1,2,2) 
h=patch(fv_new); 
set(h,'EdgeColor','b','FaceColor','w') 
axis equal	
set(gca,'XLim',[-1.1 1.1],'YLim',[-1.1 1.1],'ZLim',[-1.1 1.1]) 
view(3) 
grid on 
set(get(gca,'Title'),'String','N=3170 (after 2 subdivisions)','FontSize',30)

EXAMPLE 2:

% Generate a base icosahedron mesh 
TR=IcosahedronMesh; 
  
% Subvivide the base mesh and visualize the results 
figure('color','w') 
subplot(2,3,1) 
h=trimesh(TR); set(h,'EdgeColor','b','FaceColor','w') 
axis equal 
for i=2:6 
    subplot(2,3,i) 
    TR=SubdivideSphericalMesh(TR,1); 
    h=trimesh(TR); set(h,'EdgeColor','b','FaceColor','w') 
    axis equal 
    drawnow 
end

EXAMPLE 3: 
    
% Generate a quad cube mesh 
fv=QuadCubeMesh; 
  
% Subvivide the base mesh and visualize the results 
figure('color','w') 
subplot(2,3,1) 
h=patch(fv); set(h,'EdgeColor','b','FaceColor','w') 
view(3) 
grid on 
axis equal 
set(gca,'XLim',[-1.1 1.1],'YLim',[-1.1 1.1],'ZLim',[-1.1 1.1]) 
for i=2:6 
    subplot(2,3,i) 
    fv=SubdivideSphericalMesh(fv,1); 
    h=patch(fv); set(h,'EdgeColor','b','FaceColor','w') 
    axis equal 
    view(3) 
    grid on 
    drawnow 
    set(gca,'XLim',[-1.1 1.1],'YLim',[-1.1 1.1],'ZLim',[-1.1 1.1]) 
end