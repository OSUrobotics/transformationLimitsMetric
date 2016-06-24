function object = createObject(m)
%Declare object dimensions
object = [-1 -1 1 1 -1;-1 1 1 -1 -1];
object(3,:) = ones(1, size(object, 2));
%Add translation
object = m * object;

%Draw hand
hold on;
drawShape(object, 'none');
end