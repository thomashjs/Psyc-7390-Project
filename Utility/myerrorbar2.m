function [h1,h2]=myerrorbar2(x,y,q1,q2,drawline,linecolor,wid,markersize,flip)
%plot function with error bars
%Input:
%x: x-axis data
%y: y-axis data
%q1 and q2: the upper and lower bound of the error bars
%drawline: whether to draw the lines connecting data points
%linecolor: line color
%wid: width of the lines
%marker size: marker size
%flip: flip x, y data

if isvector(x) && ~isrow(x)
    x = x';
elseif ~isrow(x)
    error('x has to be a row')
end
if isvector(y) && ~isrow(y)
    y = y';
elseif ~isrow(y)
    error('y has to be a row')
end
if isvector(q1) && ~isrow(q1)
    q1 = q1';
elseif ~isrow(q1)
    error('q1 has to be a row')
end
if isvector(q2) && ~isrow(q2)
    q2 = q2';
elseif ~isrow(q2)
    error('q2 has to be a row')
end
if length(x) ~= length(y)
    error('x and y must be same length')
end
if ~exist('markersize','var') || isempty(markersize)
    markersize = 5;
end
if ~exist('wid','var') || isempty(wid)
    wid = 2;
end
if ~exist('drawline','var') || isempty(drawline)
    drawline = 1;
end
if ~exist('linecolor','var') || isempty(linecolor)
    linecolor = 'b';
end
if ~exist('flip','var') || isempty(flip)
    flip=0;
end

if flip==0
    h1 = plot([x;x],[(q1);(q2)]); hold on;
else
    h1 = plot([q1;q2],[(y);(y)]); hold on;
end
if drawline==1
    h2 = plot(x,y,'-o','MarkerSize',markersize);
elseif drawline==0
    if markersize < 0
    else
    h2 = plot(x,y,'o','MarkerSize',markersize);
    end
end

if exist('linecolor','var')
    set(h1,'Color',linecolor)
    if exist('h2','var')
    set(h2,'Color',linecolor,'MarkerFaceColor',linecolor)
    end
end
if exist('wid','var')
    set(h1,'LineWidth',wid)
    if exist('h2','var')
    set(h2,'LineWidth',wid)
    end
end