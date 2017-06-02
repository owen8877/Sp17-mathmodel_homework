data = load('data.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
resolution = 1e2;

[lonMesh, latMesh] = meshgrid(0:resolution:width, 0:resolution:height); 

load('3_1_p_output.mat');
% blockedData, peakCoordinates, heightd2Matrix, heightData

blabla = ones(8, 1);

for workingFactorIndex = 1:8
    coordinates = peakCoordinates{workingFactorIndex};
    working = blockedData(:, :, workingFactorIndex);
    density = ones(size(coordinates, 1), 1);
    for i = 1:size(coordinates, 1)
        density(i) = working(coordinates(i, 1), coordinates(i, 2));
    end
    density = sort(density);
%     figure
%     stem(density)
    blabla(workingFactorIndex) = mean(density, 1) / 10;
end

blabla