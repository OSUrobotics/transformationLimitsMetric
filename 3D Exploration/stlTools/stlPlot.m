function stlPlot(v, f, name, scatter)
%STLPLOT is an easy way to plot an STL object
%V is the Nx3 array of vertices
%F is the Mx3 array of faces
%NAME is the name of the object, that will be displayed as a title
%SCATTER is if there should be a scatterplot or not
if nargin ~= 4
    scatter = true;
end
if scatter
    scatter3(v(:,1),v(:,2),v(:,3),'.k'); % plots the vertices of the object
    hold on
end
object.vertices = v;
object.faces = f;
patch(object,'FaceColor',   [0.8 0.8 1.0], ...
         'EdgeColor',       'none',        ...
         'FaceLighting',    'gouraud',     ...
         'AmbientStrength', 0.15);
hold on
% Add a camera light, and tone down the specular highlighting
material('dull');

% Fix the axes scaling, and set a nice view angle
view([-135 35]);
axis image;
xlabel('X Axis');
ylabel('Y Axis');
zlabel('Z Axis');
grid on;
if nargin == 3
    title(name);
end