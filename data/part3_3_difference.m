load('simulationResult.mat');
data = load('data.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
resolution = 1e2;

[lonMesh, latMesh] = meshgrid(0:resolution:width, 0:resolution:height); 

for workingFactorIndex = 1:8
    figure
    showMatrix = simulationResult{workingFactorIndex}{5} - simulationResult{workingFactorIndex}{3};
    % contourf(lonMesh, latMesh, showMatrix', 10);
    h = imagesc(rot90(showMatrix));
    colormap(1 - gray);
%     set(h, 'alphadata', ~isnan(showMatrix))
    colorbar
    % caxis([0 cMax]);
%     hold on;
%     scatter(coordinates(:, 1) * resolution, coordinates(:, 2) * resolution, 'y');
%     if numberOn
%         for i = 1:length(coordinates)
%            text(coordinates(i, 1) * resolution, coordinates(i, 2) * resolution, ...
%                num2str(workingWithHeight(coordinates(i, 1), coordinates(i, 2))), 'Color', 'w');
%         end
%     end
%     hold off;
    title([pollution.name{workingFactorIndex} ' Difference, after 365 rounds']);
end