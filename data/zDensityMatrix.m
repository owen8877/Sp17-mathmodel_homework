function [d] = zDensityMatrix(m)
    d = ones(size(m, 1), size(m, 2));
    for i = 1:size(m, 2)
        d(:, i) = zscore(m(:, i));
    end
end

