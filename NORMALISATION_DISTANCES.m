clear

% Use uigetfile to select the CSV files
[Filename1, Path1] = uigetfile('*.csv', 'Select Healthy Pelvis Anatomical Landmarks (Palpated & Mirrored) CSV File');

% Construct the full file paths
FilePath1 = fullfile(Path1, Filename1);

% Import data from the first CSV file
Healthypoints = readtable(FilePath1);
Healthypoints = table2array(Healthypoints);

P1 = Healthypoints(:,1);
P2 = Healthypoints(:,2);
P3 = Healthypoints(:,3);
P4 = Healthypoints(:,4);
P5 = Healthypoints(:,5);

% Use uigetfile to select the CSV files
[Filename, Path] = uigetfile('*.csv', 'Select Healthy Pelvis Axes');

% Construct the full file paths
FilePath = fullfile(Path, Filename);

% Import data from the first CSV file
HealthyAxes = readtable(FilePath);
HealthyAxes = table2array(HealthyAxes)

% Extract individual vectors
x = HealthyAxes(1:3, 1);
y = HealthyAxes(4:6, 1);
z = HealthyAxes(7:9, 1);

% Select first IGES file using GUI
[filename_iges2, path_iges2] = uigetfile('*.igs', 'Select IGES File For ANATOMICAL HEIGHT');
if isequal(filename_iges2, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Select first IGES file using GUI
[filename_iges3, path_iges3] = uigetfile('*.igs', 'Select IGES File For healthy ASIS');
if isequal(filename_iges3, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end

% Import first IGES data

[ParameterData2, ~, ~, ~] = iges2matlab(fullfile(path_iges2, filename_iges2));
[ParameterData3, ~, ~, ~] = iges2matlab(fullfile(path_iges3, filename_iges3));

%%%%%%%%%%

% create coordinate system. Note: during the import process, the points are
% reversed. That is why P4 = ParameterData{1}...


P6 = [ParameterData2{1}.x;ParameterData2{1}.y;ParameterData2{1}.z];


HP3side = [ParameterData3{1}.x; ParameterData3{1}.y; ParameterData3{1}.z];

HalfWidth = HP3side-P3;
depth = P4-P3;
height = P6-P3;

% Project the difference vector from global reference frame onto the local
% reference frame

HalfWidthlocal(1) = dot(HealthyAxes(1:3,1),HalfWidth);
HalfWidthlocal(2) = dot(HealthyAxes(4:6,1),HalfWidth);
HalfWidthlocal(3) = dot(HealthyAxes(7:9,1),HalfWidth);

depthlocal(1) = dot(HealthyAxes(1:3,1),depth);
depthlocal(2) = dot(HealthyAxes(4:6,1),depth);
depthlocal(3) = dot(HealthyAxes(7:9,1),depth);

heightlocal(1) = dot(HealthyAxes(1:3,1),height);
heightlocal(2) = dot(HealthyAxes(4:6,1),height);
heightlocal(3) = dot(HealthyAxes(7:9,1),height);





% %plot the recosntructed pelvis .stl
% TR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Rizzello Daniele\RIZZELLO DANIELE_pelvis left_001.stl');
% TRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Rizzello Daniele\RIZZELLO DANIELE_pelvis right_001.stl');
% transparencyIndex1 = 0.5
% % Plot the STL model using patch
% patch('Faces', TR.ConnectivityList, 'Vertices', TR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
% patch('Faces', TRR.ConnectivityList, 'Vertices', TRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
% axis equal;
% title('Reconstructed Pelvis');
% light('Position', [0 1 0]);
% light('Position', [0 -1 0]);
% axis on;
% box on;
% rotate3d on; 
% xlabel('x (Left/Right)');
% ylabel('y (Ant/Pos)');
% zlabel('z (Pro/Dis)');
% view(16,10);
% % global graph properties
% set(gcf,'Color','w');
% hold on
%Plot the arrow of the width
arrow3([P3(1) P3(2) P3(3)], [HP3side(1) HP3side(2) HP3side(3)], 'r');
text(HP3side(1), HP3side(2), HP3side(3), 'Width', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 14);

%Plot the arrow of the width
arrow3([P3(1) P3(2) P3(3)], [P4(1) P4(2) P4(3)], 'r');
text(depthlocal(1), depthlocal(2), depthlocal(3), 'Width', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 14);

%Plot the arrow of the width
arrow3([P3(1) P3(2) P3(3)], [P6(1) P6(2) P6(3)], 'r');
text(heightlocal(1), heightlocal(2), heightlocal(3), 'Width', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 14);


% Export reconstructed hip center deviation as a CSV file with GUI for file selection
[fileNamesave, filePathsave] = uiputfile('*.csv', 'Save NORMALIZATION VALUES');
if fileNamesave ~= 0
    location = (filePathsave+"\"+fileNamesave);
    writetable(table([HalfWidthlocal,depthlocal,heightlocal]), location);
    disp(['File saved successfully: ' fullfile(filePathsave, fileNamesave)]);
else
    disp('File not saved.');
end

