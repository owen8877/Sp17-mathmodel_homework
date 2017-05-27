% convert density to standandized z-score

convertedDensity = ones(station.count, polution.count);

for i = 1:8
    convertedDensity(:, i) = (station.density(:, i) - polution.average(i)) / polution.deviation(i);
end

negativePart = find(convertedDensity < 0);
convertedDensity(negativePart) = 0;