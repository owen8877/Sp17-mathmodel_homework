function [] = mapDisplay(displayData, titleText)
    data = load('data.mat');
    pollution = data.pollution;
    station = data.station;

    x = station.x;
    y = station.y;
    z = displayData;

    % markTable = ['o'; '+'; 'x'; '*'; 's'];
    colorTable = {'yellow'; 'cyan'; 'red'; 'green'; 'blue'};

    figure
    hold on;

    figureWidth = 3e4;
    figureHeight = 2e4;

    % draw background
    resolution = 1e2;
    [lonMesh, latMesh] = meshgrid(0:resolution:figureWidth, 0:resolution:figureHeight); 
    [X, Y, Z] = griddata(x, y, z, lonMesh, latMesh, 'natural');
    mapData = load('mapData.mat');
    Z(~mapData.innerArea) = NaN;

    contourf(X, Y, Z, 30);
    % colormap(sqrt(1-gray));
    colormap(1 - gray);
    % colormap(jet);
    colorbar;

    plots = ones(5);

    minDimension = 5;
    iconScale = 3;
    % draw circles
    for i = 1:5
        currentStation = find(station.function==i);
        % scatter(x(currentStation), y(currentStation), z(currentStation) * 5, markTable(i));
        plots(i) = scatter(x(currentStation), y(currentStation), max(z(currentStation) * iconScale, minDimension), colorTable{i}, 'filled');
    end

    title(titleText)
    legend('Interpolated data', 'Living', 'Industry', 'Mountain', 'Traffic', 'Park');
end

