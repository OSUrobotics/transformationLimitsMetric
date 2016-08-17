function [ values ] = normalizenamr( values )
%NORMALIZE Summary of this function goes here
%   Detailed explanation goes here

values = values./norm(values);
end

