data = load('data.mat');
pollution = data.pollution;
station = data.station;

zDensity = ones(319, 8);
for i = 1:8
    zDensity(:, i) = zscore(station.density(:, i));
end

densityDistance = pdist(zDensity', 'euclidean');
linkData = linkage(densityDistance, 'single');
factorNumber = 5;

dendrogram(linkData, 8, 'Labels', pollution.name);
clusterData = cluster(linkData, 'maxclust', factorNumber);