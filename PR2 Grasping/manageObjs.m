%% Load in data
objInfoT = readtable('objInfo.csv');
objNumsT = readtable('objNums.csv');
setInfoT = readtable('setInfo.csv');
objInfo = table2cell(objInfoT);
objNums = table2cell(objNumsT);
setInfo = table2cell(setInfoT);
%% Make blank area to populate
objNums = sortrows(objNums);
objdata = cell(size(objNums,1),14);
objdata(:,1:2) = objNums;
%% Match it up with the extra data
for index = 1:size(objNums,1)
    oldNum = objNums{index,2};
    objdata(index,4:14) = objInfo([objInfo{:,1}] == oldNum,3:13);
    objdata{index,3} = setInfo([setInfo{:,2}] == oldNum,1)';
end
%% Get the header and save
oIh = objInfoT.Properties.VariableNames;
oNh = objNumsT.Properties.VariableNames;
sIh = setInfoT.Properties.VariableNames;
headers = [oNh sIh(1) oIh(3:13)];
writetable(cell2table(objdata,'VariableNames',headers),'objData.csv');