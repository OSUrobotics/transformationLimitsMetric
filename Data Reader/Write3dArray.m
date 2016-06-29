function Write3dArray( array, outputName )
%WRITE3DARRAY Summary of this function goes here
%   Detailed explanation goes here

%Get array dimensions
arrayX = size(array, 1)
arrayY = size(array, 2)
arrayZ = size(array, 3)
dimensions = [arrayX arrayY arrayZ]
%Write them to file
dlmwrite(outputName, dimensions);
%Write data to same file


end

