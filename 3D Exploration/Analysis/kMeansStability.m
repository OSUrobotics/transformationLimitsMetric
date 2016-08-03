function kMeansStability(index1, index2, matrix, clusters)
clc;
for j = 1:4
    together = 0;
    apart = 0;
    for i = 1:100
        kOut = kmeans(matrix,clusters,'Distance','correlation');
        if kOut(index1) == kOut(index2)
            together = together + 1;
        else
            apart = apart + 1;
        end
    end
    fprintf('Together(%i): %i\nApart(%i): %i\n\n',j,together,j,apart);
end
end
