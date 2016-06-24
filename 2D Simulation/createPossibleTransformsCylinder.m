%Returns "samples" number of x, y, theta values generated with a cylinder
function transforms = createPossibleTransformsCylinder(samples)

%Defines x, y, and theta values from a cylinder
[xValues, yValues, thetaValues] = cylinder(1, samples);

%Override default cylinder z values with desired theta values
thetaValues(1,:) = -1;
thetaValues(2,:) = 0;
thetaValues(3,:) = 1;

%Move theta info to one line to be added to x and y
thetaOutput = [thetaValues(1,:) thetaValues(2,:) thetaValues(3,:)];

%Remove abritrary second row of values
xOutput = xValues(1,:);
yOutput = yValues(1,:);

%Repeat xValues and yValues
xOutput = repmat(xOutput, 1, 3);
yOutput = repmat(yOutput, 1, 3);
%Adds zero x and y to the start 
transforms = [0 0 0; 0 0 0; -1 0 1;];
%Appends the transforms as a matrix of x, y, and theta
append = [xOutput; yOutput; thetaOutput];
transforms = [transforms append];

end