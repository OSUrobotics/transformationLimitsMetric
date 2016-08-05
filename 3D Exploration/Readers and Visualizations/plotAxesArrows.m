function plotAxesArrows( input_args, arrowScale )
%% PLOTAXESARROWS Given a list of 4x4 affine transformation matrices, plot rgb axes labels for each transformation
%==========================================================================
%
% USAGE
%
%       plotAxesArrows( input_args, arrowScale )
%
% INPUTS
%
%       input_args  - Mandatory - 4x4xN         - Matrix where N is the number of 4x4 transformation matrixes
%
%       arrowScale  - Mandatory - Double Value  - Factor by which to scale the axes arrows
%
%==========================================================================
%% Only do this all if arrowScale ~= 0
if nargin == 2 && arrowScale ~= 0
%% Define arrow coordinates
arrow = [0,0;0,1;-.1,.8;0,1;.1,.8] * arrowScale;
xArrow = [arrow(:,2) zeros(5,1) arrow(:,1) ones(5,1)];
yArrow = [arrow(:,1) arrow(:,2) zeros(5,1) ones(5,1)];
zArrow = [zeros(5,1) arrow(:,1) arrow(:,2) ones(5,1)];
%% Add NaNs for spliting plot
xArrow = [xArrow; nan(1,4)];
yArrow = [yArrow; nan(1,4)];
zArrow = [zArrow; nan(1,4)];
%% Transpose for multiplication
xArrow = xArrow.';
yArrow = yArrow.';
zArrow = zArrow.';
%% Declare matrices for the arrows to be stored in
arrowRepeat = size(input_args,3)*size(xArrow,2);
xArrowsOut = zeros(4,arrowRepeat);
yArrowsOut = zeros(4,arrowRepeat);
zArrowsOut = zeros(4,arrowRepeat);
%% Loop through and apply transformation
for transformIndex = 1:size(input_args,3)
    xArrowsOut(:,size(xArrow,2)*(transformIndex-1)+1:size(xArrow,2)*transformIndex) ...
        = input_args(:,:,transformIndex)*xArrow;
    yArrowsOut(:,size(xArrow,2)*(transformIndex-1)+1:size(xArrow,2)*transformIndex) ...
        = input_args(:,:,transformIndex)*yArrow;
    zArrowsOut(:,size(xArrow,2)*(transformIndex-1)+1:size(xArrow,2)*transformIndex) ...
        = input_args(:,:,transformIndex)*zArrow;
end
%% Plot
plotAlt(xArrowsOut(1:3,:),'r');
hold on
plotAlt(yArrowsOut(1:3,:),'g');
hold on
plotAlt(zArrowsOut(1:3,:),'b');
axis image
end

