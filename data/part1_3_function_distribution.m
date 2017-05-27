data = load('data.mat');
pollution = data.pollution;
station = data.station;

% unconvert
averageLevel = getAverageLevel(station, station.density);
disp('raw data :')
disp(array2table(averageLevel, 'VariableNames', station.functionName, 'RowNames', pollution.name))

% convert
cAverageLevel = getAverageLevel(station, station.cDensity);
disp('z-score :')
disp(array2table(cAverageLevel, 'VariableNames', station.functionName, 'RowNames', pollution.name))

function averageLevel = getAverageLevel(station, density)
    averageLevel = zeros(8, 5);
    for metal = 1:8
        for area = 1:5
            selection = find(station.function == area);
            if isempty(selection)
                averageLevel(metal, area) = 0;
            else
                averageLevel(metal, area) = mean(density(selection, metal));
            end
        end
    end
end