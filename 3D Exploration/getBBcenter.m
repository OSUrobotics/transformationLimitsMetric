function [ centerPoint ] = getBBcenter( pointList )
%GETBBCENTER Summary of this function goes here
%   Detailed explanation goes here
centerPoint = [(max(pointList(:,1))+min(pointList(:,1)))/2,(max(pointList(:,2))+min(pointList(:,2)))/2,(max(pointList(:,3))+min(pointList(:,3)))/2];


end

