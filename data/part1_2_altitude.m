data = load('data.mat');
pollution = data.pollution;
station = data.station;

maxHeight = max(station.height);

limitHeightStep = 10;
heightStep = 10;

rowName = cell(limitHeightStep + 1, 1);
for i = 1:limitHeightStep
    rowName{i} = [int2str((i-1) * heightStep) '-' int2str(i * heightStep) 'm'];
end
rowName{end} = ['>=' int2str(limitHeightStep * heightStep) 'm'];

% unconvert
averageLevel = getAverageLevel(station, station.density);
disp('raw data :')
disp(array2table(averageLevel, 'VariableNames', pollution.name, 'RowNames', rowName))

% convert
cAverageLevel = getAverageLevel(station, station.cDensity);
disp('z-score :')
disp(array2table(cAverageLevel, 'VariableNames', pollution.name, 'RowNames', rowName))

function averageLevel = getAverageLevel(station, density)
    limitHeightStep = 10;
    heightStep = 10;
    averageLevel = zeros(limitHeightStep + 1, 8);
    for i = 1:limitHeightStep
        for metal = 1:8
            selection = find(station.height >= (i - 1) * heightStep & station.height < i * heightStep);
            if isempty(selection)
                averageLevel(i, metal) = 0;
            else
                averageLevel(i, metal) = mean(density(selection, metal));
            end
        end
    end
    
    for metal = 1:8
        selection = find(station.height >= limitHeightStep * heightStep);
        if isempty(selection)
            averageLevel(limitHeightStep + 1, metal) = 0;
        else
            averageLevel(limitHeightStep + 1, metal) = mean(density(selection, metal));
        end
    end
end