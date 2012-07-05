a = [-1 , 1, -1,  1];
b = [ 1 , 1, -1, -1];
% [c d] = xcorr(a,b);
c = conv(a,b);
figure(143)
plot(c/length(a));


a = [-1 , 1, -1];
b = [ 1 ,-1,  1];
% [c d] = xcorr(a,b);
c = conv(a,b);
figure(144)
plot(c/length(a));


a = [-1 ,-1,  1];
b = [ 1 ,-1, -1];
% [c d] = xcorr(a,b);
c = conv(a,b);
figure(145)
plot(c/length(a));

