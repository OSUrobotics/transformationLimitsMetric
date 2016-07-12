% This code is to replace clc and all of the other clearing functions, with a confirmation.
function cl(str)
if nargin ~= 1
    str = input('Sure you want to clear everything? [Y/N] ','s');
end

if isequal(str, 'Y') || isequal(str, 'y')
    evalin('base', 'clear functions');  % Clear functions
    evalin('base', 'fclose all');       % Close all open files
    clf;                                % Clear the figure
    close all;                          % Close all windows
    dbclear all;                        % Clear breakpoints
    evalin('base', 'clear all');        % Clear the workspace
    clc;                                % Clear the console
end
end