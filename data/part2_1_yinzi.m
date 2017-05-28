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

% figure;
biplot(coeff(:,1:3), 'scores', score(:,1:3), 'varlabels', pollution.name);

rotatedCoeff = rotatefactors(coeff(:, 1:factorNumber));
restore = score * rotatedCoeff + mu(1:factorNumber);

disp(array2table(rotatedCoeff, 'RowNames', pollution.name, 'VariableNames', {'f1', 'f2', 'f3', 'f4', 'f5'}))

covariance = zeros(factorNumber, 5);
for i = 1:factorNumber
    for j = 1:5 % function Types
        fVector = zeros(station.count, 1);
        fVector(station.function == j) = 1;
        cMatrix = corrcoef(restore(:, i), fVector);
        covariance(i, j) = cMatrix(1, 2);
    end
end

disp(covariance)