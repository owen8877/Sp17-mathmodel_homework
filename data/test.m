data = load('data.mat');
pollution = data.pollution;
station = data.station;

x = station.x;
y = station.y;
z = station.density(:, 2);
% [X, Y, Z] = griddata(x, y, z, linspace(min(x),max(x))', linspace(min(y),max(y)), 'v4');

% surf(X, Y, Z);
% contourf(X, Y, Z, 30);
% draw polution plot
figure
scatter(x, y, z / 3, z, 'filled');
% colormap(gray);

density = [station.density station.x station.y];
densityDistance = pdist(density, @stationPolutionDistance);
linkData = linkage(densityDistance, 'single');
%figure
%dendrogram(linkData, 319);
clusterData = cluster(linkData, 'maxclust', 5);

figure
% scatter(x, y, 'filled', 'cdata', clusterData);
scatter(x, y, clusterData * 10, clusterData, 'filled');
% colormap(gray);

function distance = stationPolutionDistance(s1, s2)
    % the former 8 are polutions, the latter 2 geo
    distance = pdist([s1(2); s2(2)], 'euclidean'); %* pdist([s1(9:10); s2(9:10)], 'euclidean'); 
end