function [ outputVectors ] = generateTranslationVectors( resolution )
%GENERATETRANSLATIONVECTORS Returns a number of normalized vectors
%   Resolution determines the density of said vectors.  The value given is
%   converted to number of samples returned using the following formula:
%   Samples = 

% %Creates a list of values from with a length of resolution + 1
% singleValues = -resolution / 2:resolution / 2;
% 
% singleValues = [singleValues 0];
% %Creates a list of all possible vectors from combining the single values
% combinedValues = combvec(singleValues, singleValues, singleValues);
% %Normalizes all the generated vectors
% normalizedVectors = normalize(combinedValues');
% %Loop through and remove NaN values
% outputVectors = []
% for I = normalizedVectors'
%     if isfinite(I(1))
%         outputVectors = [outputVectors I];
%     end
% end

%% Actally Working
disp('Do not use this function: generateTranslationVectors. Use makeTransformationValues and makeTransformationMatrix instead');
% [x,y,z] = sphere(floor(sqrt(resolution)));
% outputVectors = [x(:) y(:) z(:)];
% scatter3(outputVectors(:,1),outputVectors(:,2),outputVectors(:,3),'.r');
end

