%Draws a hand with two fingers and a palm
function [fingerA, fingerB, palm] = createHand(m)
%Declare finger dimensions
finger = [-1.5 -1.5 1.5 1.5 -1.5;-0.5 0.5 0.5 -0.5 -0.5];
finger(3,:) = ones(1, size(finger, 2));
%Declare local finger translations
tFingerA = matrixTranslate(0, 2);
tFingerB = matrixTranslate(0, -2);
%Convert to global translations
tFingerA = m * tFingerA;
tFingerB = m * tFingerB;
%Declare two absolute fingers
fingerA = tFingerA * finger;
fingerB = tFingerB * finger;

%Declare palm dimensions
palm = [-0.5 -0.5 0.5 0.5 -0.5;-1.5 1.5 1.5 -1.5 -1.5];
palm(3,:) = ones(1, size(palm, 2));
%Declare local palm translations
tPalm = matrixTranslate(2, 0);
%Convert to global translations
tPalm = m * tPalm;
%Declare absolute palm
palm = tPalm * palm;

%Draw hand
hold on;
drawShape(fingerA, '-k.');
drawShape(fingerB, '-k.');
drawShape(palm, '-k.');

end