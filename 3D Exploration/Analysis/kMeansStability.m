index1 = 132;
index2 = 35;
clc;
for j = 1:100
    together = 0;
    apart = 0;
    for i = 1:100
        kOut = kmeans(kIn,15,'Distance','correlation');
        if kOut(index1) == kOut(index2)
            together = together + 1;
        else
            apart = apart + 1;
        end
    end
    fprintf('Together(%i): %i\n',j,together);
    fprintf('Apart(%i): %i\n',j,apart);
    disp(' ');
end
