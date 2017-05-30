data = load('data.mat');
pcaData = load('pcaData.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
resolution = 1e2;
x = station.x;
y = station.y;

mapData = load('mapData.mat');

[lonMesh, latMesh] = meshgrid(0:resolution:width, 0:resolution:height); 
blockedData = zeros(width / resolution + 1, height / resolution + 1, pcaData.count);

for i = 1:pcaData.count
    S = scatteredInterpolant(x, y, pcaData.score(:, i), 'natural');
    Z = S(lonMesh, latMesh);
    Z(~mapData.innerArea) = NaN;
    blockedData(:, :, i) = Z';
end

% contourf(lonMesh, latMesh, blockedData(:, :, 2)', 10);
% colorbar;

working = blockedData(:, :, 5);
derivative1Matrix = working * NaN;
derivative2Matrix = working * NaN;
coordinates = [];
for i = 2:size(working, 1)-1
    for j = 2:size(working, 2)-1
        if isnan(working(i, j))
            continue
        end
        
        dx1 = working(i, j) - working(i-1, j);
        dy1 = working(i, j) - working(i, j-1);
        dx2 = working(i+1, j) + working(i-1, j) - 2*working(i, j);
        dy2 = working(i, j+1) + working(i, j-1) - 2*working(i, j);
        derivative1Matrix(i, j) = dx1 + dy1;
        derivative2Matrix(i, j) = dx2 + dy2;
        
        % if this point is the largest, mark it
        largest = true;
        searchSize = 3;
        for k = -min(searchSize, i-1):min(searchSize, size(working, 1) - i)
            for l = -min(searchSize, j-1):min(searchSize, size(working, 2) - j)
                if k == 0 && l == 0
                    continue
                elseif working(i+k, j+l) > working(i, j) || isnan(working(i+k, j+l))
                    largest = false;
                    break
                end
            end
        end
        if largest
            coordinates = [coordinates; [i, j]];
        end
    end    
end

% subplot(1, 2, 1);
% % contourf(lonMesh, latMesh, derivate2Matrix' ./ derivative1Matrix', 10);
% contourf(lonMesh, latMesh, derivative1Matrix', 10);
% colorbar;
% caxis([-100, 100]);
% subplot(1, 2, 2);
% contourf(lonMesh, latMesh, working', 10);
% colorbar;
% % caxis([-100, 100]);

% very naive method
figure
hold on;
contourf(lonMesh, latMesh, working', 10);
scatter(coordinates(:, 1) * resolution, coordinates(:, 2) * resolution, 'filled', 'r');
hold off;

% figure
pollutionRate = zeros(size(coordinates, 1), 1);
for i = 1:size(coordinates, 1)
    pollutionRate(i) = working(coordinates(i, 1), coordinates(i, 2));
end
% stem(pollutionRate);
yValue = mean(pollutionRate) + std(pollutionRate) * 2;
% refline(0, yValue);

realPeak = coordinates(pollutionRate > yValue, :);
% very naive method
figure
hold on;
contourf(lonMesh, latMesh, working', 10);
scatter(realPeak(:, 1) * resolution, realPeak(:, 2) * resolution, 'filled', 'b');
hold off;