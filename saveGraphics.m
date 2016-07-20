function saveGraphics( filename, dimensions, useStyles )
%SAVEGRAPHICS write to file a png with the dimensions requested, in [height width] format
% useStyles (optional boolean) by default or false sets the background color to white, true overrides with whatever current figure styles are in use
dimensions = dimensions/10;
set(gcf,'PaperUnits','inches')
set(gcf,'PaperPosition',[0 0 10 10*dimensions(1)/dimensions(2)])
if nargin == 3 && useStyles
    set(gcf,'InvertHardcopy','off');
else
    set(gcf,'InvertHardcopy','on');
end
print(gcf,filename,'-dpng',sprintf('-r%i',dimensions(2)));
end