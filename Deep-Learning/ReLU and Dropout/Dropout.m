% Dropout function 
% ym = Dropout(y, ratio)
% y is the output vector and ratio is the ratio of the dropout of the
% output vector.
% ym contains zeros for as many elements as the ratio and 1/(1-ratio) for
% the other elements.
% The reason that we multiply the other element by 1/(1-ratio) is to
% compensate for the loss of output due to the dropped elements. 

function ym = Dropout(y, ratio)
    [m, n] = size(y);
    ym = zeros(m,n);

    num = round(m*n*(1-ratio));
    idx = randperm(m*n, num);
    ym(idx) = 1/(1-ratio);
end
