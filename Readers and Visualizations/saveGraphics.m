function saveGraphics( filename, dimensions )
%SAVEGRAPHICS write to file a png with the dimensions requested, in [height width] format
dimensions = dimensions/10;
set(gcf, 'PaperUnits','inches')
set(gcf, 'PaperPosition', [0 0 10 10*dimensions(1)/dimensions(2)])
print(gcf,filename,'-dpng',sprintf('-r%i',dimensions(2)));
end

