function avg = MovAvgFilter(x)

persistent prevAvg n xbuf
persistent firstRun 

if isempty(firstRun)
    % Avg data number buffer selection 
    n = 10;
    xbuf = x*ones(n+1,1);
    %initialization 
    k=1;
    prevAvg = x;
    firstRun = 1;
end

for m =1:n
    xbuf(m) = xbuf(m+1);
end
xbuf(n+1) = x;

avg = prevAvg + (x-xbuf(1))/n;

prevAvg = avg;