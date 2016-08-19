%Plots out an ROC curve assuming all of the necissary vars are loaded

clf;
hold on;

valuesToTest = 1:0.25:50;
sizesToTest = [2,3,4,5,6,7,8];

for size = sizesToTest
    FPROut = [];
    TPROut = [];
    
    for i = valuesToTest
        clusterOut = DBSCAN(clusterIn,i,size);

        dataOut = clustersAgainstOriginal(clusterOut,names);
        conditionPositive = dataOut(1) + dataOut(4);  %Sum of true positives and false negatives
        conditionNegative = dataOut(2) + dataOut(3);  %Sum of true negatives and false positives
        truePositive = dataOut(1);
        falsePositive = dataOut(3);

        truePositiveRate = truePositive / conditionPositive;
        falsePositiveRate = falsePositive / conditionNegative;

        FPROut = [FPROut falsePositiveRate];
        TPROut = [TPROut truePositiveRate];

    end

    scatter3(FPROut,TPROut,valuesToTest,'filled');
end

title('DBSCAN ROC Curve');
xlabel('FPR (False Positive / Condition Negative)');
ylabel('TPR (True Positive / Condition Positive)');
axis square;

legend('2','3','4','5','6','7','8');