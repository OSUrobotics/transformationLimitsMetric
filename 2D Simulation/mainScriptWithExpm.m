%Main script to run all other functions from

%Clear it all up
clear
clc
clf

%Declare constants
MATRIX_IDENTITY = eye(3, 3);
%Defines the number of points to move to.
%There are actually 3 tests per sample, one for each theta value
NUMBER_OF_XY_SAMPLES = 20;
NUMBER_OF_T_SAMPLES = 8;
%Defines the number of steps to take on the way to each extreme
STEPS_TO_EXTREMES = 25;
%The percentage of area colliding before we label a real colision
%Set to 100 to ignore collisions
COLLISION_THRESHOLD = 0.1;
%How far in units an object should go before terminating
DISTANCE_AMPLIFICATION = 5;

%Number of objects is calculated by
%(NUMBER_OF_SAMPLES + 1) * STEPS_TO_EXTREMES * 3
%Note: This does not account for the loss of objects caused by termination

%Draw the hand
[fingerA, fingerB, palm] = createHand(MATRIX_IDENTITY);

%Draw the object
object = createObject(MATRIX_IDENTITY);

%Get the list of possible extremes
transforms = createPossibleTransformsCylinderForExpm(NUMBER_OF_XY_SAMPLES, NUMBER_OF_T_SAMPLES);

%Keeps track of objects drawn
positionCount = 0;

%Output table
%Values are (x, y, t, % complete [0-1])
outputTable = [];

%For every end point in transforms
for I = transforms
    %Loop through the number of steps to get there
    for J = 1:STEPS_TO_EXTREMES
        %Define the fraction
        stageCoefficient = (J / STEPS_TO_EXTREMES);
        
        %Create the transformation matrices
        x = I(1);
        y = I(2);
        t = I(3);
        %Normalize and add amplification
        l = sqrt(x^2 + y^2 + t^2);
        Xt = (x/l * (stageCoefficient)) * DISTANCE_AMPLIFICATION;
        Yt = (y/l * (stageCoefficient)) * DISTANCE_AMPLIFICATION;
        Tt = (t/l * (stageCoefficient)) * DISTANCE_AMPLIFICATION;
        %Do exponentiation of matrix... which is to say, MAGIC!
        mTransformation = expm([0 -Tt Xt; Tt 0 Yt; 0 0 0]);
        
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
            outputTable(:,positionCount + 1) = [I(1) I(2) I(3) stageCoefficient];
            positionCount = positionCount + 1;
            break;
        elseif (J / STEPS_TO_EXTREMES) == 1
            %Terminate this endpoint and record as infinity\
            disp('INFINITY REACHED');
            outputTable(:,positionCount + 1) = [I(1) I(2) I(3) -1];
            positionCount = positionCount + 1;
            break;
        end

    end
end

%Set view
axis([-6 6 -6 6]);
axis equal;
%Write title
xySamples = num2str(NUMBER_OF_XY_SAMPLES);
tSamples = num2str(NUMBER_OF_T_SAMPLES);
stepSamples = num2str(STEPS_TO_EXTREMES);
title(strcat(xySamples, {' XY Samples, '}, tSamples, {' Theta Samples, '}, stepSamples, {' Steps to Extremes'}));