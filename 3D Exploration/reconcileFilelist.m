clc
filepath2transforms = 'matts_stls/grasp_transforms';
filepath2good = 'matts_stls/good';
filepath2bad = 'matts_stls/bad';
%% Get list of names
transformNames = dir(filepath2transforms);
goodNames = dir(filepath2good);
badNames = dir(filepath2bad);
%% Prune
transformNames = transformNames(3:end,:);
goodNames = goodNames(3:end,:);
badNames = badNames(3:end,:);
%% idk what