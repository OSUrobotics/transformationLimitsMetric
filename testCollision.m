%Returns the percentage of objectA inside objectB
function percentageColliding = testCollision(objectA, objectB)
simpleObjectA = [objectA(1,:); objectA(2,:)];
simpleObjectB = [objectB(1,:); objectB(2,:)];

aObjectA = polyarea(objectA(1,:), objectA(2,:));
[colX, colY] = polybool('intersection', simpleObjectA(1,:), simpleObjectA(2,:), simpleObjectB(1,:), simpleObjectB(2,:));
aIntersection = polyarea(colX, colY);

percentageColliding = aIntersection / aObjectA;
percentageColliding = percentageColliding * 100;
end