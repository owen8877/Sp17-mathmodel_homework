data = load('data.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
wresolution = 2e3;
hresolution = 2e3;

blockData = struct();
blockData.sum = zeros(width / wresolution, height / hresolution, pollution.count);
count = zeros(width / wresolution, height / hresolution);

for i = 1:station.count
    bx = fix(station.x(i) / wresolution) + 1;
    by = fix(station.y(i) / hresolution) + 1;
    for j = 1:pollution.count
        blockData.sum(bx, by, j) = blockData.sum(bx, by, j) + station.density(i, j);
    end
    count(bx, by) = count(bx, by) + 1;
end

% [lon, lat] = meshgrid(0:wresolution:width - 1, 0:hresolution:height - 1);

blockData.density = blockData.sum ./ count;

image(rot90(blockData.density(:, :, 2)))
colormap(1 - gray);