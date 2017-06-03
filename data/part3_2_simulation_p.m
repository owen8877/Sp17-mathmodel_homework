data = load('data.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
resolution = 1e2;

[lonMesh, latMesh] = meshgrid(0:resolution:width, 0:resolution:height); 

load('3_1_p_output.mat');
% blockedData, peakCoordinates, heightd2Matrix, heightData

workingFactorIndex = 2;

round = 365;
pollutionSpeed = 3e-2;
pollutionBaseLine = [1.5 100 80 230 1500 6 30 320];
kai = 0.2;
psai = 2e-3;
numberOn = false;
intermediateOn = true;

if intermediateOn
    picsNumber = 9;
else
    picsNumber = 0;
end

simulationResult = cell(pollution.count, 5);

% for workingFactorIndex = 1:8
    working = blockedData(:, :, workingFactorIndex);
    coordinates = peakCoordinates{workingFactorIndex};

    cMax = max(max(working)) * 0.9;
    
    unpolluted = simulate(round, working, heightd2Matrix, ...
        0.0, 0.0, coordinates, ...
        kai, 0.0, picsNumber, workingFactorIndex, lonMesh, latMesh, cMax, 'unpolluted');
    unpollutedWithHeight = simulate(round, working, heightd2Matrix, ...
        0.0, 0.0, coordinates, ...
        kai, psai, 0, workingFactorIndex, lonMesh, latMesh, cMax, 'unpollutedWithHeight');
    workingWithoutHeight = simulate(round, working, heightd2Matrix, ...
        pollutionSpeed, pollutionBaseLine(workingFactorIndex), coordinates, ...
        kai, 0.0, picsNumber, workingFactorIndex, lonMesh, latMesh, cMax, 'withoutHeight');
    workingWithHeight = simulate(round, working, heightd2Matrix, ...
        pollutionSpeed, pollutionBaseLine(workingFactorIndex), coordinates, ...
        kai, psai, 0, workingFactorIndex, lonMesh, latMesh, cMax, 'wihtHeight');

    simulationResult{workingFactorIndex}{1} = working;
    simulationResult{workingFactorIndex}{2} = unpolluted;
    simulationResult{workingFactorIndex}{3} = unpollutedWithHeight;
    simulationResult{workingFactorIndex}{4} = workingWithoutHeight;
    simulationResult{workingFactorIndex}{5} = workingWithHeight;
    
    figure;
    suptitle({pollution.name{workingFactorIndex}, ''});
    subplot(221);
    contourf(lonMesh, latMesh, working', 10);
    colorbar;
    % colormap(parula);
    colormap(hot);
    caxis([0 cMax]);
    hold on;
    scatter(coordinates(:, 1) * resolution, coordinates(:, 2) * resolution, 'y');
    if numberOn
        for i = 1:length(coordinates)
           text(coordinates(i, 1) * resolution, coordinates(i, 2) * resolution, ...
               num2str(working(coordinates(i, 1), coordinates(i, 2))), 'Color', 'w');
        end
    end
    hold off;
    title('original');
    
    subplot(222);
    contourf(lonMesh, latMesh, unpolluted', 10);
    % colorbar;
    caxis([0 cMax]);
    hold on;
    scatter(coordinates(:, 1) * resolution, coordinates(:, 2) * resolution, 'y');
    if numberOn
        for i = 1:length(coordinates)
           text(coordinates(i, 1) * resolution, coordinates(i, 2) * resolution, ...
               num2str(unpolluted(coordinates(i, 1), coordinates(i, 2))), 'Color', 'w');
        end
    end
    hold off;
    title('unpolluted');

    subplot(223);
    contourf(lonMesh, latMesh, workingWithoutHeight', 10);
    % colorbar;
    caxis([0 cMax]);
    hold on;
    scatter(coordinates(:, 1) * resolution, coordinates(:, 2) * resolution, 'y');
    if numberOn
        for i = 1:length(coordinates)
           text(coordinates(i, 1) * resolution, coordinates(i, 2) * resolution, ...
               num2str(workingWithoutHeight(coordinates(i, 1), coordinates(i, 2))), 'Color', 'w');
        end
    end
    hold off;
    title('without height');

    subplot(224);
    contourf(lonMesh, latMesh, workingWithHeight', 10);
    % colorbar;
    caxis([0 cMax]);
    hold on;
    scatter(coordinates(:, 1) * resolution, coordinates(:, 2) * resolution, 'y');
    if numberOn
        for i = 1:length(coordinates)
           text(coordinates(i, 1) * resolution, coordinates(i, 2) * resolution, ...
               num2str(workingWithHeight(coordinates(i, 1), coordinates(i, 2))), 'Color', 'w');
        end
    end
    hold off;
    title('with height');
% end

function result = simulate(round, working, heightd2Matrix, pollutionSpeed, ...
    pollutionBaseLine, coordinates, kai, psai, subplotNumber, ...
    workingFactorIndex, lonMesh, latMesh, cMax, tag)
    needFigure = subplotNumber ~= 0;

    if needFigure
        figure;
        rowPlot = fix(sqrt(subplotNumber));
        columnPlot = fix(ceil(subplotNumber / rowPlot));
        titleText = ['Simulation on metal ' int2str(workingFactorIndex) ' ' tag];
        suptitle({titleText, ''});
        drawStep = fix(round / (rowPlot * columnPlot));
    end
    
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
        fallbackd2Matrix = fillmissing(derivative2Matrix, 'constant', 0, 1);
        fallbackd2Matrix = fillmissing(fallbackd2Matrix, 'constant', 0, 2);
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
                densityDifference(i, j) = kai * d2 + psai * heightd2Matrix(i, j) * working(i, j);
            end
        end

        % secretly retrieve peak points
        for index = 1:size(coordinates, 1)
            localX = coordinates(index, 1);
            localY = coordinates(index, 2);
            densityDifference(localX, localY) = pollutionBaseLine + ...
                pollutionSpeed * working(localX, localY) + densityDifference(localX, localY);
        end

        working = working + densityDifference;

        if ~needFigure || mod(r, drawStep) ~= 0
            continue
        end

        subplot(rowPlot, columnPlot, r / drawStep);
        contourf(lonMesh, latMesh, working', 5);
        colormap(hot);
        caxis([0 cMax]);
        title(['after ' int2str(r) ' round'])
    end
    if needFigure
        colorbar
    end
    result = working;
end