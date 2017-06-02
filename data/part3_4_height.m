data = load('data.mat');
pollution = data.pollution;
station = data.station;

width = 3e4;
height = 2e4;
resolution = 1e2;

[lonMesh, latMesh] = meshgrid(0:resolution:width, 0:resolution:height); 

contourf(lonMesh, latMesh, heightData', 10);
colorbar
