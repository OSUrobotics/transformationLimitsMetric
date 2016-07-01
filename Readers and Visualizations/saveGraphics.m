function saveGraphics( filename, resolution )
%SAVEGRAPHICS write to file a png with the resolution requested, in [height width] format
resolution = resolution;
set(gcf, 'PaperUnits','inches')
set(gcf, 'PaperPosition', [0 0 1 resolution(1)/resolution(2)])

print(gcf,filename,'-dpng',sprintf('-r%i',resolution(1)));
end

