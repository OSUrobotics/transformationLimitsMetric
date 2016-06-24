%Returns "samples" number of x, y, theta values generated with a cylinder
function transforms = createPossibleTransformsCylinderForExpm(xYSamples, tSamples)
%Defines x, y, and theta values from a cylinder
[xValues, yValues, thetaValues] = cylinder(1, xYSamples);
%Override default cylinder z values with desired theta values
thetaValues(1,:) = -1;
for i = 1:tSamples + 1
    thetaValues(i + 1,:) = -1 + (2 * (i / tSamples));
end
%Move theta info to one line to be added to x and y
thetaOutput = [];
for i = 1:tSamples + 1
    thetaOutput = [thetaOutput thetaValues(i,:)];
end
%Remove abritrary second row of values
xOutput = xValues(1,:);
yOutput = yValues(1,:);
%Repeat xValues and yValues
xOutput = repmat(xOutput, 1, tSamples + 1);
yOutput = repmat(yOutput, 1, tSamples + 1);
%Assembles output
transforms = [xOutput; yOutput; thetaOutput];
end
