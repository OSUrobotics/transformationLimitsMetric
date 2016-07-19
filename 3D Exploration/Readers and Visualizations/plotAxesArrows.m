function [ output_args ] = plotAxesArrows( input_args )
%% PLOTAXESARROWS Given a list of 4x4 affine transformation matrices, plot rgb axes labels for each transformation
%   Detailed explanation goes here
%% Define arrow coordinates
arrow = [0,0;0,1;-.1,.8;0,1;.1,.8];
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
arrowRepeat = size(input_args,3)*size(xArrow,1);
xArrowsOut = zeros(arrowRepeat,3);
yArrowsOut = zeros(arrowRepeat,3);
zArrowsOut = zeros(arrowRepeat,3);
%% Loop through and apply transformation
for transformIndex = 1:size(input_args,3)
    
end
end

