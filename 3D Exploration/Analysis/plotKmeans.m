%A short script that plots the results of kmeans with various cluster sizes
%and outputs the value where the slope is closest to -1.
clf;
maxes = [];
mins = [];
means = [];
for i = 1:100
    [~,~,sumD] = kmeans(matFlat,i,'Distance','correlation');
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
axis equal;

tmp = abs(diff(means)+1);
[~,idx] = min(tmp);
disp(idx);