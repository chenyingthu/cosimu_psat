function createhourloadshape(Config)
%% Initialize variables.
filename = 'LoadShape2.csv';
delimiter = '';

%% Format string for each line of text:
%   column1: double (%f)
% For more information, see the TEXTSCAN documentation.
formatSpec = '%f%[^\n\r]';

%% Open the text file.
fileID = fopen(filename,'r');

%% Read columns of data according to format string.
% This call is based on the structure of the file used to generate this
% code. If an error occurs for a different file, try regenerating the code
% from the Import Tool.
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);

%% Close the text file.
fclose(fileID);

%% Allocate imported array to column variable names
allDay = dataArray{:, 1};

%% Clear temporary variables
clearvars filename delimiter formatSpec fileID dataArray ans;
origTStep  = 60*60*24 / length(allDay);
nPoint = 0;
tStep = 0;
if Config.simuType == 0
    tStep = Config.lfTStep;
else
    tStep = Config.dynTStep;
end
nPoint = length(allDay)/24;

for iHour = 1 : 24
    hourDataOld = allDay(nPoint*(iHour-1) + 1 : nPoint*iHour);
    P = polyfit([1:nPoint]', hourDataOld, 3);
    hourDataNew = polyval(P, [tStep/origTStep : tStep/origTStep : nPoint]);
    save(['loadshapeHour',num2str(iHour)], 'hourDataNew');
end