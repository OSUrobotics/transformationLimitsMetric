function [ transformationFP, objectFP, surfaceFP, handFP, outputFP ] = filenamesFromComponentsWiggles( objectNum, subjectNum, graspNum, extreme, stepNum )
%% FILENAMESFROMCOMPONENTSWIGGLES Takes in filepath components and outputs the filenames for the hand, object, transformations, and output file
%==========================================================================
%
% USAGE
%
%       [ transformationFP, objectFP, surfaceFP, handFP, outputFP ] = filenamesFromComponentsWiggles( objectNum, subjectNum, graspNum, extreme, stepNum )
%
% INPUTS
%
%       objectNum           - Mandatory - Integer Value             - Object Number component of the desired file name
%
%       subjectNum          - Mandatory - Integer Value             - Subject Number component of the desired file name
%
%       graspNum            - Mandatory - Integer Value             - Grasp Number component of the desired file name
%
%       extreme             - Mandatory - String                    - Following string of the desired file name
%
%       stepNum             - Optional  - Integer Value or Range    - Step Number component of the desired file name
%
% OUTPUTS
%
%       transformationFP    - Mandatory - Filepath String           - Path to the desired transformation matrix file
%
%       objectFP            - Mandatory - Filepath String           - Path to the object model file
%
%       surfaceFP           - Mandatory - Filepath String           - Path to the object surface samples file
%
%       handFP              - Mandatory - Filepath String           - Path to the hand model file
%
%       outputFP            - Mandatory - Filepath String           - Path to the simulation output file
%
% EXAMPLE
%
%       To get the paths to object 7, subject 9, grasp 2, 'extreme0_prime_' steps 1 to 9 :
%       >>  [ transformationFP, objectFP, surfaceFP, handFP, outputFP ] = filenamesFromComponentsWiggles( 7, 9, 2, 'extreme0_prime_', 1:9 )
%
%==========================================================================

transformationFP = sprintf('handAndAlignment/transforms/obj%i_sub%i_grasp%i_%s_Transformation.txt',objectNum,subjectNum,graspNum,extreme);
handFP = sprintf('handAndAlignment/hand/obj%i_sub%i_grasp%i_%s.stl',objectNum,subjectNum,graspNum,extreme);
if nargin == 5 && length(stepNum) ~= 1
    outputFP = cell(1,length(stepNum));
    for stepNumIndex = 1:length(stepNum)
        outputFP{stepNumIndex} = sprintf('OutputWiggle/Wiggle%sStep%iobj%i_sub%i_grasp%i_%sAreaIntersection.csv','%i',stepNum(stepNumIndex),objectNum,subjectNum,graspNum,extreme);
    end
elseif nargin == 5
    outputFP = sprintf('OutputWiggle/Wiggle%sStep%iobj%i_sub%i_grasp%i_%sAreaIntersection.csv','%i',stepNum,objectNum,subjectNum,graspNum,extreme);
else
    outputFP = sprintf('OutputWiggle/Wiggle%sStep%sobj%i_sub%i_grasp%i_%sAreaIntersection.csv','%i','%s',objectNum,subjectNum,graspNum,extreme);
end
objectLinking = table2cell(readtable('handAndAlignment/obj_dict.csv'));
objectFP = sprintf('sampleSTLs/%s',objectLinking{[objectLinking{:,1}] == objectNum,3});
surfaceFP = sprintf('sampleSTLs/%s',objectLinking{[objectLinking{:,1}] == objectNum,4});
end

