function [ ptsOut ] = applyWiggles(pts,wiggles)
%% APPLYWIGGLES Takes wiggle values in and applies them to a set of vertices
%% Pad the points for affine transformations
pts = pts.';
pts = [pts; ones(1,size(pts,2))];
%% Prepare for and loop through creating the steps
ptsOut = zeros(size(pts,1),size(pts,2),size(wiggles,2));
for transformIndex = 1:size(wiggles,2)
    ptsOut(:,:,transformIndex) = makehgtform('translate',wiggles(1:3,transformIndex),'axisrotate',wiggles(4:6,transformIndex),wiggles(7,transformIndex)) * pts;
end
%% Crop and reshape for normal usage
ptsOut = permute(ptsOut(1:3,:,:),[2 1 3]);
end