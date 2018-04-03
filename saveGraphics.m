function saveGraphics( filename, dimensions, useStyles )
%SAVEGRAPHICS write to file an image of given type with the dimensions requested, in [height width] format
% useStyles (optional boolean) by default or false sets the background color to white, true overrides with whatever current figure styles are in use
set(gcf,'PaperUnits','inches')
set(gcf,'PaperPosition',[0 0 dimensions(1) dimensions(2)])
if nargin == 3 && useStyles
    set(gcf,'InvertHardcopy','off');
else
    set(gcf,'InvertHardcopy','on');
end
strDot = strfind(filename, '.');
strDot = strDot(end);
strImageType = filename(strDot+1:end);
print(gcf,filename,strcat('-d', strImageType),sprintf('-r%i',dimensions(2)));
end