data = load('data.mat');
pcaData = load('pcaData.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
resolution = 1e2;

[lonMesh, latMesh] = meshgrid(0:resolution:width, 0:resolution:height); 

output31 = load('3_1_output.mat');
blockedData = output31.blockedData;
peakCoordinates = output31.peakCoordinates;

workingFactorIndex = 5;

working = blockedData(:, :, workingFactorIndex);

% working = working + 1 - min(min(working));

figure
contourf(lonMesh, latMesh, working', 10);
colorbar;
caxis([-2 2]);

round = 100;
pollutionSpeed = 0.3;
kai = 0.2;
% kai = 1;

unpolluted = simulate(round, working, 0.0, peakCoordinates{workingFactorIndex}, kai);
working = simulate(round, working, pollutionSpeed, peakCoordinates{workingFactorIndex}, kai);

figure
contourf(lonMesh, latMesh, working' - unpolluted', 10);
colorbar;

% subplot(122);
% contourf(lonMesh, latMesh, working', 10);
% colorbar;
% caxis([-2 15]);

function result = simulate(round, working, pollutionSpeed, coordinates, kai)
    % figure
    for r = 1:round
        % calculating 1st and 2nd derivative
        derivative2Matrix = working * NaN;
        for i = 2:size(working, 1)-1
            for j = 2:size(working, 2)-1
                if isnan(working(i, j))
                    continue
                end

                dx2 = working(i+1, j) + working(i-1, j) - 2*working(i, j);
                dy2 = working(i, j+1) + working(i, j-1) - 2*working(i, j);
                derivative2Matrix(i, j) = dx2 + dy2;
            end    
        end

        % calculating differential
        densityDifference = working * NaN;
        fallbackd2Matrix = fillmissing(derivative2Matrix, 'nearest', 1);
        fallbackd2Matrix = fillmissing(fallbackd2Matrix, 'nearest', 2);
        for i = 2:size(working, 1)-1
            for j = 2:size(working, 2)-1
                if isnan(working(i, j))
                    continue
                end

                if ~isnan(derivative2Matrix(i, j))
                    d2 = derivative2Matrix(i, j);
                else
                    % use fallback d2
                    d2 = fallbackd2Matrix(i, j);
                end
                densityDifference(i, j) = kai * d2;
            end
        end

        % secretly retrieve peak points
        for index = 1:size(coordinates, 1)
            localX = coordinates(index, 1);
            localY = coordinates(index, 2);
            densityDifference(localX, localY) = pollutionSpeed + densityDifference(localX, localY);
        end

        working = working + densityDifference;

        if mod(r, 10) ~= 0
            continue
        end

        % subplot(3, 4, r / 10 + 1);
        % subplot(3, 4, r + 1);
        % contourf(lonMesh(120:125, 240:245), latMesh(120:125, 240:245), working(240:245, 120:125)', 25);
        % contourf(lonMesh, latMesh, working', 10);
        % colorbar;
        % caxis([-2 2]);
    %     title(['after ' int2str(r) ' round'])
    %     disp(['round ' int2str(r)])
    %     disp(working(10:20, 25:35)')
    %     disp(densityDifference(10:20, 25:35)')

    end
    result = working;
end