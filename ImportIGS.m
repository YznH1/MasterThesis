clear

% Select first IGES file using GUI
[filename_iges1, path_iges1] = uigetfile('*.igs', 'Select IGES File For Reconstructed Hip Anatomical Land Marks');
if isequal(filename_iges1, 0)
    disp('User canceled IGES file selection. Exiting...');
    return;
end


% Import first IGES data
[ParameterData, ~, ~, ~] = iges2matlab(fullfile(path_iges1, filename_iges1));

%%%%%%%%%%

% create coordinate system. Note: during the import process, the points are
% reversed. That is why P4 = ParameterData{1}...

P4 = [ParameterData{1}.x;ParameterData{1}.y;ParameterData{1}.z];
P3 = [ParameterData{2}.x;ParameterData{2}.y;ParameterData{2}.z];
P2 = [ParameterData{3}.x;ParameterData{3}.y;ParameterData{3}.z];
P1 = [ParameterData{4}.x;ParameterData{4}.y;ParameterData{4}.z];
P5 = P3;

%Create the local reference frame

R = PLANAX(P1,P2,P3,P4,P5);

%Rotate the axes into the correct convention. First set the angle of
%rotation about the local reference frame's axis

Rot = [0;0;0.5];

%Apply the rotation

R = ROTTER(R,Rot);

% Define the x, y, and z coordinates of the first point of the tip of the
% local x-axis
x1 = (R(1,1)*100+P3(1));
y1 = (R(2,1)*100+P3(2));
z1 = (R(3,1)*100+P3(3));

% Define the x, y, and z coordinates of the second point of the tip of the
% local y-axis
x2 = (R(4,1)*100+P3(1));
y2 = (R(5,1)*100+P3(2));
z2 = (R(6,1)*100+P3(3));

% Define the x, y, and z coordinates of the third point of the tip of the
% local z-axis
x3 = (R(7,1)*100+P3(1));
y3 = (R(8,1)*100+P3(2));
z3 = (R(9,1)*100+P3(3));

%%%%%%%%%%%%

%Plot the anatomical landmarks

plot3(P1(1), P1(2), P1(3), 'x', 'MarkerSize', 10, 'LineWidth', 2);
hold on
plot3(P2(1), P2(2), P2(3), 'o',  'LineWidth', 2);
plot3(P3(1), P3(2), P3(3), '+',  'MarkerSize', 10, 'LineWidth', 2);
plot3(P4(1), P4(2), P4(3), '*',  'MarkerSize', 10, 'LineWidth', 2);
plot3(P5(1), P5(2), P5(3), 'square', 'MarkerSize', 10, 'LineWidth', 2);
plot3([x1 x2 x3], [y1 y2 y3], [z1 z2 z3], '.' );
grid on
xlim([-500 500]);
ylim([-500 500]);
zlim([-500 500]);

%plot the recosntructed pelvis .stl
TR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Rizzello Daniele\RIZZELLO DANIELE_pelvis left_001.stl');
TRR = stlread('C:\Users\Yazan\OneDrive\Desktop\MEng project\3DP-Prosthesis-Reconsrtucion\Rizzello Daniele\RIZZELLO DANIELE_pelvis right_001.stl');
transparencyIndex1 = 0.5
% Plot the STL model using patch
patch('Faces', TR.ConnectivityList, 'Vertices', TR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
patch('Faces', TRR.ConnectivityList, 'Vertices', TRR.Points, 'FaceColor', [0.89 0.85 0.79], 'EdgeColor', 'none','FaceLighting','gouraud','AmbientStrength',0.50, 'SpecularStrength',0.2,'FaceAlpha',transparencyIndex1);
axis equal;
title('Reconstructed Pelvis');
light('Position', [0 1 0]);
light('Position', [0 -1 0]);
axis on;
box on;
rotate3d on; 
xlabel('x (Left/Right)');
ylabel('y (Ant/Pos)');
zlabel('z (Pro/Dis)');
view(16,10);
% global graph properties
set(gcf,'Color','w');

%Plot the arrows of the local reference frame axes
arrow3([P3(1) P3(2) P3(3)], [x1 y1 z1], 'r');
text(x1, y1, z1, 'Anatomical X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 14);

arrow3([P3(1) P3(2) P3(3)], [x2 y2 z2], 'g');
text(x2, y2, z2+5, 'Anatomical Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 14);

arrow3([P3(1) P3(2) P3(3)], [x3 y3 z3], 'b');
text(x3, y3, z3+10, 'Anatomical Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 14);

%%%%%%%%%%

% %Plot the arrows of the global reference frame axes
% 
% arrow3([0 0 0], [100 0 0], 'r');
% text(100, 0, 0, 'X Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'r', 'FontSize', 14);
% 
% arrow3([0 0 0], [0 100 0], 'g');
% text(0, 100, 0, 'Y Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'g', 'FontSize', 14);
% 
% arrow3([0 0 0], [0 0 100], 'b');
% text(0, 0, 100, 'Z Axis', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', 'Color', 'b', 'FontSize', 14);

legend('Right PSIS "P1"','Left PSIS "P2"','Mid Point of ASIS "P3"','Mid Point of PSIS "P4"','Mid Point of ASIS "P5"','');



% Export R and P5 as a CSV file with GUI for file selection
[fileName, filePath] = uiputfile('*.csv', 'Save R and P5 as CSV');
if fileName ~= 0
    location = (filePath+"\"+fileName)
    PP5 = [P5;0;0;0;0;0;0]
    writetable(table([R],[PP5]), location);
    disp(['File saved successfully: ' fullfile(filePath, fileName)]);
else
    disp('File not saved.');
end



