function drawShape(m, style)
if strcmp(style, 'none')
    plot(m(1,:), m(2,:));
else
    plot(m(1,:), m(2,:), style);
end
end