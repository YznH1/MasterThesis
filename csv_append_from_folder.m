clear
% Prompt user to select a folder
folderPath = uigetdir('Select a folder containing CSV files');

% Get a list of all CSV files in the selected folder
fileList = dir(fullfile(folderPath, '*.csv'));

% Initialize variables to store columns
firstColumn = [];
%secondColumn = [];

% Loop through each CSV file
for i = 1:length(fileList)
    % Read the CSV file using readtable
    
    filePath = fullfile(folderPath, fileList(i).name);
    tableData = readtable(filePath);
    
    % Append the first column to firstColumn variable
    firstColumn = [firstColumn; tableData{1, 1:9}];
    
    % Append the second column to secondColumn variable
    %secondColumn = [secondColumn; tableData{1, 2}];
end

% Stack the columns vertically
stackedData = [firstColumn ]; %, secondColumn

% Prompt user to select a location to save the result
[saveFileName, savePath] = uiputfile('*.csv', 'Save Stacked Data As', 'stacked_data.csv');

% Check if the user canceled the save operation
if isequal(saveFileName, 0) || isequal(savePath, 0)
    disp('Save operation canceled. Data not saved.');
else
    % Write the stacked data to a new CSV file
    saveFilePath = fullfile(savePath, saveFileName);
    writematrix(stackedData, saveFilePath);
    disp('Data has been stacked and saved successfully.');
end