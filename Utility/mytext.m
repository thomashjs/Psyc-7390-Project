function mytext(xratio, yratio, thisText, fontSize)

if ~exist('fontSize', 'var')
    fontSize = 10;
end

ax = gca;

xrange = ax.XLim(2) - ax.XLim(1);
thisx = ax.XLim(1) + xrange*xratio;

yrange = ax.YLim(2) - ax.YLim(1);
thisy = ax.YLim(1) + yrange*yratio;

text(thisx, thisy, thisText,'FontSize',fontSize);