function [bin_corr, x_bin, y_bin, ntrial_bin, ind] = binCorr(xdata, ydata, nbin, myfunc, type)
%[bin_corr, x_bin, y_bin, ntrial_bin, ind] = binCorr(xdata, ydata, nbin, myfunc, type)
%xdata and ydata are two vectors representing two variable of interest
%This function bin the trials based on xdata, and compute the x and y value (using myfunc; defalut: mean(x))
%of the trials within each bin.

if isrow(xdata)
    xdata = xdata';
elseif ~isvector(xdata)
    error('xdata should be a vector');
end
if isrow(ydata)
    ydata = ydata';
elseif ~isvector(ydata)
    error('ydata should be a vector');
end
if ~exist('myfunc')
    myfunc = @(x) mean(x);
end
if ~exist('type', 'var')
    type = 'Pearson';
end

ind = isnan(xdata) | isnan(ydata);
xdata(ind) = [];
ydata(ind) = [];

qunatile_vec = linspace(0, 1, nbin+1);

%Get variables of interest as a function of four bins of the x-axis
%variable
[~, ind]=histc(xdata, [-Inf quantile(xdata,qunatile_vec(2:end-1)) Inf]);

x_bin = nan(nbin,1);
y_bin = nan(nbin,1);
ntrial_bin = nan(nbin,1);

for i = 1:nbin
    
    x_bin(i) = mean(xdata(ind==i));
    y_bin(i) = myfunc(ydata(ind==i));
    
    %x_bin(i) = mean(xdata(ind==i));
    %y_bin(i) = mean(ydata(ind==i));
    ntrial_bin(i) = sum(ind==i);
end

bin_corr = corr(x_bin, y_bin, 'type', type);

% debug;
% nbin = 4;
% xdata = rand(1000,1);
% ydata = abs(randn(1000,1).*xdata);