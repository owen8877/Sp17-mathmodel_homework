data = load('data.mat');
pollution = data.pollution;
station = data.station;

draw_which = 2;

displayData = station.cDensity(:, draw_which);

mapDisplay(displayData, ['Pollution of ' pollution.name{draw_which}]);