%Main script to run all other functions from

%Clear it all up
clear
clc
clf

%Declare constants
MATRIX_IDENTITY = eye(3, 3);
%Defines the number of points to move to.
%There are actually 3 tests per sample, one for each theta value
NUMBER_OF_SAMPLES = 25;
%Defines the number of steps to take on the way to each extreme
STEPS_TO_EXTREMES = 50;
%The percentage of area colliding before we label a real colision
%Set to 100 to ignore collisions
COLLISION_THRESHOLD = 0.1;
%The value in degrees that a rotation will end at
END_ROTATION = 90;

%Number of objects is calculated by
%(NUMBER_OF_SAMPLES + 1) * STEPS_TO_EXTREMES * 3
%Note: This does not account for the loss of objects caused by termination

%Draw the hand
[fingerA, fingerB, palm] = createHand(MATRIX_IDENTITY);

%Draw the object
object = createObject(MATRIX_IDENTITY);

%Get the list of possible extremes
transforms = createPossibleTransformsCylinder(NUMBER_OF_SAMPLES);

%translation amplified to ensure object clears hand at max
transforms(1,:) = transforms(1,:) * 5;
transforms(2,:) = transforms(2,:) * 5;

%Keeps track of objects drawn
positionCount = 0;

%For every end point in transforms
for I = transforms
    %Loop through the number of steps to get there
    for J = 1:STEPS_TO_EXTREMES
        %Define the fraction
        stageCoefficient = (J / STEPS_TO_EXTREMES);
        
        %Create the transformation matrices
        mTransformation = matrixTranslate(I(1) * stageCoefficient, I(2) * stageCoefficient);
        mTransformation = mTransformation * matrixRotate(I(3) * END_ROTATION * stageCoefficient);
        
        %Add object
        obj = createObject(mTransformation);
        
        %Test object collision
        collisionPercentage(1) = testCollision(obj, fingerA);
        collisionPercentage(2) = testCollision(obj, fingerB);
        collisionPercentage(3) = testCollision(obj, palm);
        
        maxPercentage = max(collisionPercentage);
        
        if maxPercentage > COLLISION_THRESHOLD
            %Terminate this endpoint and record distance traveled
            disp('COLLISION DETECTED')
            break;
        elseif (J / STEPS_TO_EXTREMES) == 1
            %Terminate this endpoint and record as infinity\
            disp('INFINITY REACHED');
            break;
        end
        
        %Count up number of objects
        positionCount = positionCount + 1;
    end
end

%Set view
axis([-6 6 -6 6]);
axis equal;
%Write title
titleCount = num2str(positionCount(1));
title(strcat(titleCount, {' Squares Drawn'}));