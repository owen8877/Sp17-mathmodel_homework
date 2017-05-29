data = load('data.mat');
pollution = data.pollution;
station = data.station;

% first draw a box graph
% boxplot(station.density, 'labels', pollution.name);
% set(gca, 'YScale', 'log')
% ylabel('Density (ug/g)')
% xlabel('Pollution Type')
% title('Box graph of pollution density')

zDensity = ones(319, 8);
for i = 1:8
    zDensity(:, i) = zscore(station.density(:, i));
end

% [Loadings, specificVar, T, stats] = factoran(zDensity, 3, 'rotate', 'none');
% fprintf('p is %f\n', stats.p);

[coeff, score, latent, tsquared, explained, mu] = pca(zDensity);

cutoff = 0.85;
factorNumber = find((cumsum(latent)./sum(latent)) > cutoff, 1);

% factorNumber = 5;
% figure;
% biplot(coeff(:, 1:2), 'scores', score(:, 1:2), 'varlabels', pollution.name);
% title('PCA on pollution density-2D')
% figure
% biplot(coeff(:, 1:3), 'scores', score(:, 1:3), 'varlabels', pollution.name);
% title('PCA on pollution density-3D')

rotatedCoeff = rotatefactors(coeff(:, 1:factorNumber));
restore = score * rotatedCoeff;

varName = cell(factorNumber, 1);
for i = 1:factorNumber
    varName{i} = ['f' int2str(i)];
end
disp(array2table(rotatedCoeff, 'RowNames', pollution.name, 'VariableNames', varName))

functionPercent = zeros(319, 5);
countttt = zeros(319, 1);
for i = 1:319
    % select the stations near this one
    radius = 1e3;
    distanceVector = sqrt((station.x - station.x(i)).^2 + (station.y - station.y(i)).^2);
    nearStations = find(distanceVector < radius);
    countttt(i) = size(nearStations, 1);
    for j = 1:5
        functionPercent(i, j) = size(find(station.function(nearStations) == j), 1) / countttt(i);
    end
end

covariance = zeros(factorNumber, 5);
for i = 1:factorNumber
    for j = 1:5 % function Types
%         fVector = zeros(station.count, 1);
%         fVector(station.function == j) = 1;
%         cMatrix = corrcoef(restore(:, i), fVector);
        cMatrix = corrcoef(restore(:, i), functionPercent(:, j));
        covariance(i, j) = cMatrix(1, 2);
    end
end

disp(covariance)
% stem(countttt)
% mapDisplay(restore(:, 3), 'Blabla');