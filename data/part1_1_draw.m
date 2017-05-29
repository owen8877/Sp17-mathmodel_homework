data = load('data.mat');
pollution = data.pollution;
station = data.station;

draw_which = 2;

x = station.x;
y = station.y;
z = station.cDensity(:, draw_which);
% z = station.height;

markTable = ['o'; '+'; 'x'; '*'; 's'];
colorTable = {'yellow'; 'cyan'; 'red'; 'green'; 'blue'};

figure
hold on;

figureWidth = 3e4;
figureHeight = 2e4;

% draw background
resolution = 1e2;
[lonMesh, latMesh] = meshgrid(0:resolution:figureWidth, 0:resolution:figureHeight); 
[X, Y, Z] = griddata(x, y, z, lonMesh, latMesh, 'v4');
border = struct();
convhullSelection = convhull(x, y);
border.x = x(convhullSelection);
border.y = y(convhullSelection);
Z(~inpolygon(lonMesh, latMesh, border.x, border.y)) = NaN;

contourf(X, Y, Z, 30);
% surf(X, Y, Z);
% colormap(sqrt(1-gray));
colormap(1 - gray);

plots = ones(5);

% draw circles
for i = 1:5
    currentStation = find(station.function==i);
    % scatter(x(currentStation), y(currentStation), z(currentStation) * 5, markTable(i));
    plots(i) = scatter(x(currentStation), y(currentStation), max(z(currentStation) * 3, 0.2), colorTable{i}, 'filled');
end

title(['Pollution of ' pollution.name{draw_which}])
legend('Interpolated data', 'Living', 'Industry', 'Mountain', 'Traffic', 'Park');