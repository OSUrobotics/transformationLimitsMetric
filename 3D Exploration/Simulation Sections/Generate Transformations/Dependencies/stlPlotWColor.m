function stlPlotWColor(vertices, faces, scatter, name, amount)
%STLPLOT is a hacky way to plot an stl object with color based on a collision value.  You probably should think twice about using this awful awful piece of code
%V is the Nx3 array of vertices
%F is the Mx3 array of faces
%SCATTER is if there should be a scatterplot or not, default none
%NAME is the name of the object, that will be displayed as a title
%% Plot the vertices if selected to do so
if nargin == 2 || (nargin > 2 && scatter)
    plot3(vertices(:,1),vertices(:,2),vertices(:,3),'.k');
    hold on
end
%% Get the vertices and faces into the expected format
object.vertices = vertices;
object.faces = faces;
%% Plot all of the facets of the stl
patch(object,'FaceColor',   interp1([0, 0.00226599439678135],[0.8 0.8 1.0 ; 1 0 0],amount), ...
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
if nargin > 3
    title(name, 'FontSize', 48);
end