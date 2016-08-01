clf;
maxes = [];
mins = [];
means = [];
for i = 1:100
    [~,~,sumD] = kmeans(kIn,i,'Distance','correlation');
    hold on;
    maxes = [maxes max(sumD)];
    mins = [mins min(sumD)];
    means = [means mean(sumD)];
end
plot(1:100,maxes);
plot(1:100,mins);
plot(1:100,means);
legend('Max','Min','Mean');
axis([1,100,0,5]);
