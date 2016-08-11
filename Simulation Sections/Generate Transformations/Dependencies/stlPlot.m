function stlPlot(vertices, faces, scatter, name)
%STLPLOT is an easy way to plot an STL object
%V is the Nx3 array of vertices
%F is the Mx3 array of faces
%SCATTER is if there should be a scatterplot or not, default none
%NAME is the name of the object, that will be displayed as a title
%% Plot the vertices if selected to do so
if nargin == 2 && scatter
    plot3(vertices(:,1),vertices(:,2),vertices(:,3),'.k');
    hold on
end
%% Get the vertices and faces into the expected format
object.vertices = vertices;
object.faces = faces;
%% Plot all of the facets of the stl
patch(object,'FaceColor',   [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);
hold on
%% Make the material ready for lighting
material('dull');
%% Fix the axes scaling, and set a nice view angle
view([-135 35]);
axis image;
%% Label it all
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
grid on;
%% Add title if wanted
if nargin == 4
    title(name);
end