data = load('data.mat');
pollution = data.pollution;
station = data.station;

load('pcaData.mat');
load('simulationResult.mat');

[rows, columns] = size(factorOutput{1});

totalScore = zeros(rows * columns, 5);
for i = 1:5
    totalScore(:, i) = factorOutput{i}(:);
end

restoredData = totalScore * rotatedCoeff' * diag(stdVector) + ones(rows * columns, 1) * meanVector;
for i = 1:8
    figure
    contourf(lonMesh, latMesh, reshape(restoredData(:, i), rows, columns)', 10);
    colorbar;
    title(int2str(i));
end