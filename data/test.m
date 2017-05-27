data = load('data.mat');
polution = data.polution;
station = data.station;

x = station.x;
y = station.y;
z = station.cDensity(:, 1);
[X, Y, Z] = griddata(x, y, z, linspace(min(x),max(x))', linspace(min(y),max(y)), 'v4');

% surf(X, Y, Z);
contour(X, Y, Z, 30);