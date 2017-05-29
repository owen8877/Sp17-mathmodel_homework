data = load('data.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
wResolution = 3e3;
hResolution = 2e3;
wCount = width / wResolution;
hCount = height / hResolution;

% cornerWeight = 1;
% sideWeight = 1;
% centerWeight = 1;
% weightMatrix = [cornerWeight sideWeight cornerWeight; sideWeight centerWeight sideWeight; cornerWeight sideWeight cornerWeight];
% weightMatrix = weightMatrix / sum(sum(weightMatrix));

blockData = struct();
blockData.sum = zeros(wCount + 2, hCount + 2, pollution.count);
count = zeros(wCount + 2, hCount + 2);

for i = 1:station.count
    bx = fix(station.x(i) / wResolution) + 2;
    by = fix(station.y(i) / hResolution) + 2;
    
    for j = 1:pollution.count
        blockData.sum(bx, by, j) = blockData.sum(bx, by, j) + station.density(i, j);
    end
    count(bx, by) = count(bx, by) + 1;
end

zScore_xNaN = @(x) bsxfun(@rdivide, bsxfun(@minus, x, mean(x,'omitnan')), std(x, 'omitnan'));

tmpDensity = blockData.sum ./ count;
% for i = 1:size(tmpDensity, 3)
%     workingMatrix = tmpDensity(:, :, i);
%     workingMatrix = zScore_xNaN(workingMatrix);
%     blockData.density(:, :, i) = workingMatrix(2:wCount+1, 2:wCount+1, :);
% end
for i = 1:size(tmpDensity, 3)
    blockData.density(:, :, i) = tmpDensity(2:wCount+1, 2:wCount+1, i);
end

h = imagesc(rot90(blockData.density(:, :, 2)));
set(h, 'alphadata', ~isnan(blockData.density(:, :, 2)))
colormap([[1 0 0]; 1 - gray]);
% colormap(1 - gray);
caxis([-2 2]);
colorbar