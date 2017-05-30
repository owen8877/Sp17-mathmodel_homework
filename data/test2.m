[x, y] = meshgrid(-20:0.05:20, -20:0.05:20);

z = exp(-0.5 * x .^ 2) .* exp(-0.5 * y .^ 2);

figure;
subplot(3, 3, 1);
surf(x, y, z);
xlabel('x');
ylabel('y');

kai = 5;

for r = 1:8
    d2 = z * NaN;
    for i = 2:size(z, 1)-1
        for j = 2:size(z, 2)-1
            d2(i, j) = z(i+1, j) + z(i-1, j) + z(i, j+1) + z(i, j-1) - 4 * z(i, j);
        end
    end

    d2 = fillmissing(d2, 'linear');

    z = z + d2 * kai;
    % figure
    subplot(3, 3, r + 1);
    surf(x, y, z);
end